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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/dual.dart';

import '../../../core/protocol.dart';
import '../../../models/variant.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {
  final AppInstance instance;
  final int id;

  ProductInfoBloc({required this.id, required this.instance})
      : super(ProductInfoState.initial()) {
    on<ProductInfoEventOK>(_onOK);
    on<ProductSetFavorite>(_onMethodSetFavorite);
    on<ProductInfoRequest>(_onMethodRequest);
    on<ChangeInUse>(_onchangeInUse);
    on<ChangeDisplay>(_onchangeDisplay);
  }

  Future<void> _onchangeInUse(
      ChangeInUse event, Emitter<ProductInfoState> emit) async {
    Variant variant = event.variant;

    emit(state.copyWith(inUse: variant, current: ProducInfoStatus.success));
  }

  Future<void> _onchangeDisplay(
      ChangeDisplay event, Emitter<ProductInfoState> emit) async {
    String image = event.image;
    int index = event.index;

    emit(state.copyWith(
        display: image, index: index, current: ProducInfoStatus.success));
  }

  Future<void> _onMethodSetFavorite(
      ProductSetFavorite event, Emitter<ProductInfoState> emit) async {
    final status = event.status;
    DualResult updated = state.dual;

    emit(state.copyWith(
        dual: updated, liked: status, current: ProducInfoStatus.success));

    await instance.favorites.smart(id: id, status: state.liked);
  }

  void _onOK(ProductInfoEventOK event, Emitter<ProductInfoState> emit) {
    emit(ProductInfoState.initial());
  }

  Future<void> _onMethodRequest(
      ProductInfoRequest event, Emitter<ProductInfoState> emit) async {
    emit(state.copyWith(current: ProducInfoStatus.loading));

    try {
      DualResult? result = await instance.products.info(id: id);

      if (result?.status == Protocol.ok) {
        Variant first = result?.model2.first;
        String display = first.images.first.image;

        emit(state.copyWith(
            display: display,
            liked: result!.model3 == 1 ? true : false,
            current: ProducInfoStatus.success,
            status: result.status,
            dual: result,
            variants: result.model2,
            inUse: result.model2[0]));
      } else {
        emit(state.copyWith(
            current: ProducInfoStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(
          current: ProducInfoStatus.failure, status: Protocol.unknownError));
    }
  }
}
