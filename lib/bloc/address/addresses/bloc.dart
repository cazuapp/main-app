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

import 'package:cazuapp/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../../core/defaults.dart';
import '../../../components/dual.dart';
import '../../../core/protocol.dart';
import '../../../models/address.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AppInstance instance;

  AddressBloc({required this.instance}) : super(const AddressState()) {
    on<AddressList>(_onAddressList,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onAddressList(
    AddressList event,
    Emitter<AddressState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == AddressStatus.initial) {
        emit(state.copyWith(status: AddressStatus.loading));

        final posts = await _fetchItems(emit: emit);
        return emit(
          state.copyWith(
            status: AddressStatus.success,
            addresses: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts =
          await _fetchItems(startIndex: state.addresses.length, emit: emit);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: AddressStatus.success,
                addresses: List.of(state.addresses)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: AddressStatus.failure));
    }
  }

  Future<List<Address>> _fetchItems(
      {required Emitter<AddressState> emit, int startIndex = 0}) async {
    DualResult? response =
        await instance.address.get(offset: startIndex, limit: _postLimit);

    if (response?.model2 != null) {
      emit(state.copyWith(total: response?.model2));
    }

    if (response?.status == Protocol.empty) {
      return List<Address>.empty();
    }

    List<Address>? addresses = response?.model;

    if (addresses!.isEmpty) {
      return List<Address>.empty();
    }

    return addresses.toList();
  }
}
