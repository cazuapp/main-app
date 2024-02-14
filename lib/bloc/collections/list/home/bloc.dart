/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
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
import 'package:cazuapp/core/defaults.dart';
import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/core/protocol.dart';
import 'package:cazuapp/models/product.dart';

import 'package:cazuapp/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductCollectionBloc
    extends Bloc<ProductCollectionEvent, ProductCollectionState> {
  AppInstance instance;

  ProductCollectionBloc({required this.instance})
      : super(const ProductCollectionState()) {
    on<ProductCollectionsFetched>(
      _onHomeFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    on<SetID>(_onSetName);

    /* Resets original status */

    on<Init>(_onInit);
  }

  Future<void> _onSetName(
    SetID event,
    Emitter<ProductCollectionState> emit,
  ) async {
    final name = event.name;
    final id = event.id;

    return emit(
      state.copyWith(name: name, id: id),
    );
  }

  Future<void> _onInit(
    Init event,
    Emitter<ProductCollectionState> emit,
  ) async {
    emit(const ProductCollectionState());
  }

  Future<void> _onHomeFetch(
    ProductCollectionsFetched event,
    Emitter<ProductCollectionState> emit,
  ) async {
    try {
      if (state.status == ProductCollectionStatus.initial) {
        final posts = await _fetchHomeItems(emit: emit);

        return emit(
          state.copyWith(
            status: ProductCollectionStatus.success,
            products: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts =
          await _fetchHomeItems(emit: emit, startIndex: state.products.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProductCollectionStatus.success,
                products: List.of(state.products)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: ProductCollectionStatus.failure));
    }
  }

  Future<List<Product>> _fetchHomeItems(
      {required Emitter<ProductCollectionState> emit,
      int startIndex = 0}) async {
    DualResult? response = await instance.products
        .get(offset: startIndex, limit: _postLimit, collection: state.id);

    if (response?.model2 != null) {
      emit(state.copyWith(total: response?.model2));
    }

    if (response?.status == Protocol.empty) {
      return List<Product>.empty();
    }

    if (response?.model.isEmpty) {
      return List<Product>.empty();
    }

    return response?.model.toList();
  }
}
