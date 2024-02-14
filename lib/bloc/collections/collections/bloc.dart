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
import '../../../models/collection.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  AppInstance instance;

  CollectionBloc({required this.instance}) : super(const CollectionState()) {
    on<CollectionsFetched>(_onCollectionFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onCollectionFetched(
    CollectionsFetched event,
    Emitter<CollectionState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == CollectionStatus.initial) {
        emit(state.copyWith(status: CollectionStatus.loading));

        final collections = await _fetchItems(emit: emit);
        return emit(
          state.copyWith(
            status: CollectionStatus.success,
            collections: collections,
            hasReachedMax: false,
          ),
        );
      }

      final collections =
          await _fetchItems(emit: emit, startIndex: state.collections.length);
      collections.isEmpty
          ? emit(state.copyWith(
              hasReachedMax: true, status: CollectionStatus.success))
          : emit(
              state.copyWith(
                status: CollectionStatus.success,
                collections: List.of(state.collections)..addAll(collections),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: CollectionStatus.failure));
    }
  }

  Future<List<Collection>> _fetchItems(
      {required Emitter<CollectionState> emit, int startIndex = 0}) async {
    DualResult? response =
        await instance.collections.get(offset: startIndex, limit: _postLimit);

    if (response?.model2 != null) {
      emit(state.copyWith(total: response?.model2));
    }

    if (response?.status == Protocol.empty) {
      return List<Collection>.empty();
    }

    if (response?.model.isEmpty) {
      return List<Collection>.empty();
    }

    return response?.model.toList();
  }
}
