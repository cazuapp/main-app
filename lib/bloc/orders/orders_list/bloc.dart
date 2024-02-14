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

import 'package:cazuapp/models/order_list.dart';
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

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  AppInstance instance;

  OrderBloc({required this.instance}) : super(const OrderState()) {
    on<OrderFetch>(
      _onOrderFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<OrderSet>(_onSet);
  }

  Future<void> _onSet(
    OrderSet event,
    Emitter<OrderState> emit,
  ) async {
    String item = event.request;

    emit(const OrderState());
    emit(state.copyWith(param: item));
  }

  Future<void> _onOrderFetched(
    OrderFetch event,
    Emitter<OrderState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == OrderStatus.initial) {
        emit(state.copyWith(status: OrderStatus.loading));
        final posts =
            await _fetchItems(emit: emit, startIndex: state.orders.length);
        return emit(
          state.copyWith(
            status: OrderStatus.success,
            orders: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts =
          await _fetchItems(emit: emit, startIndex: state.orders.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: OrderStatus.success,
                orders: List.of(state.orders)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: OrderStatus.failure));
    }
  }

  Future<List<OrderList>> _fetchItems(
      {required Emitter<OrderState> emit, int startIndex = 0}) async {
    DualResult? status = await instance.orders
        .get(param: state.param, offset: startIndex, limit: _postLimit);

    if (status?.model2 != null) {
      emit(state.copyWith(total: status?.model2));
    }

    if (status?.status == Protocol.empty) {
      return List<OrderList>.empty();
    }

    List<OrderList>? orders = status?.model;

    if (orders!.isEmpty) {
      return List<OrderList>.empty();
    }

    return orders;
  }
}
