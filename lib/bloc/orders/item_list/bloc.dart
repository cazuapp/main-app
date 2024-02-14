/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023 - Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'dart:async';

import 'package:cazuapp/models/item.dart';

import 'package:cazuapp/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../../core/defaults.dart';
import '../../../components/dual.dart';
import '../../../core/protocol.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit + 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class OrderItemsBloc extends Bloc<OrderItemEvent, OrderItemsState> {
  AppInstance instance;

  OrderItemsBloc({required this.instance}) : super(const OrderItemsState()) {
    on<ItemsFetch>(
      _onItemsFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<SetOrder>(
      _onSetOrder,
    );
  }

  Future<void> _onSetOrder(
    SetOrder event,
    Emitter<OrderItemsState> emit,
  ) async {
    int id = event.id;

    emit(state.copyWith(id: id));
  }

  Future<void> _onItemsFetched(
    ItemsFetch event,
    Emitter<OrderItemsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == OrderItemsStatus.initial) {
        emit(state.copyWith(status: OrderItemsStatus.loading));
        final posts = await _fetchItems(emit: emit);
        return emit(
          state.copyWith(
            status: OrderItemsStatus.success,
            items: posts,
            hasReachedMax: false,
          ),
        );
      }

      final items =
          await _fetchItems(emit: emit, startIndex: state.items.length);

      items.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: OrderItemsStatus.success,
                items: List.of(state.items)..addAll(items),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: OrderItemsStatus.failure));
    }
  }

  Future<List<Item>> _fetchItems(
      {required Emitter<OrderItemsState> emit, int startIndex = 0}) async {
    DualResult? status = await instance.orders
        .getItems(id: state.id, offset: startIndex, limit: _postLimit);
    emit(state.copyWith(total: status?.model2));

    if (status?.status == Protocol.empty) {
      return List<Item>.empty();
    }

    List<Item>? orders = status?.model;

    if (orders!.isEmpty) {
      return List<Item>.empty();
    }

    return orders;
  }
}
