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

class ProductCollectionSearchBloc
    extends Bloc<HomeSearchEvent, ProductCollectionSearchState> {
  AppInstance instance;

  ProductCollectionSearchBloc({required this.instance})
      : super(const ProductCollectionSearchState()) {
    on<SearchRequest>(
      _onSearchRequest,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SetID>(_onSetName);

    on<OnScroll>(_onScroll);

    on<SearchReset>(_onSearchReset);
    on<Init>(_onInit);
  }

  Future<void> _onSetName(
    SetID event,
    Emitter<ProductCollectionSearchState> emit,
  ) async {
    final name = event.name;
    final id = event.id;

    return emit(
      state.copyWith(name: name, id: id),
    );
  }

  Future<void> _onInit(
    Init event,
    Emitter<ProductCollectionSearchState> emit,
  ) async {
    final query = state.text;

    emit(state.copyWith(text: query));
  }

  Future<void> _onSearchReset(
    SearchReset event,
    Emitter<ProductCollectionSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        total: 0,
        text: "",
        status: ProductSearchStatus.success,
        products: <Product>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onScroll(
    OnScroll event,
    Emitter<ProductCollectionSearchState> emit,
  ) async {
    if (!state.hasReachedMax) {
      await _onSearchRequest(SearchRequest(text: state.text), emit);
    }
  }

  Future<void> _onSearchRequest(
      SearchRequest event, Emitter<ProductCollectionSearchState> emit) async {
    if (state.hasReachedMax) return;

    final text = event.text;

    emit(state.copyWith(text: text));

    try {
      if (state.status == ProductSearchStatus.initial) {
        final posts = await _fetchResults(emit: emit);

        return emit(
          state.copyWith(
            status: ProductSearchStatus.success,
            products: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts =
          await _fetchResults(emit: emit, startIndex: state.products.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProductSearchStatus.success,
                products: List.of(state.products)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: ProductSearchStatus.failure));
    }
  }

  Future<List<Product>> _fetchResults(
      {required Emitter<ProductCollectionSearchState> emit,
      int startIndex = 0}) async {
    DualResult? response = await instance.products.search(
        value: state.text, offset: startIndex, limit: _postLimit, id: state.id);

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
