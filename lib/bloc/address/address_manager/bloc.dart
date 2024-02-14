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

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/models/address.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';

import '../../../src/cazuapp.dart';
import '../../../validators/optional.dart';
import '../../../validators/zip.dart';

part 'event.dart';
part 'state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AddressManagerBloc extends Bloc<AddressFetchEvent, AddressManagerState> {
  final AppInstance instance;

  AddressManagerBloc({required this.instance})
      : super(const AddressManagerState.initial()) {
    on<AddressAddressRequest>(_onRequest);
    on<AddressDelete>(_onAddressDelete);
    on<AddressManagerOK>(_onAddressOk);
  }

  Future<void> _onAddressOk(
      AddressManagerOK event, Emitter<AddressManagerState> emit) async {
    emit(const AddressManagerState.initial());
  }

  Future<void> _onAddressDelete(
      AddressDelete event, Emitter<AddressManagerState> emit) async {
    emit(state.copyWith(current: AddressStatus.loading));

    final int id = event.id;

    try {
      int? result = await instance.address.delete(id: id);

      if (result == Protocol.ok) {
        emit(state.copyWith(current: AddressStatus.success, status: result));
      } else {
        String? errmsg = "An error has occured";

        emit(state.copyWith(
            current: AddressStatus.failure, errmsg: errmsg, status: result));
      }
    } catch (_) {
      emit(state.copyWith(
          current: AddressStatus.failure, status: Protocol.unknownError));
    }
  }

  Future<void> _onRequest(
      AddressAddressRequest event, Emitter<AddressManagerState> emit) async {
    emit(state.copyWith(current: AddressStatus.loading));

    final id = event.id;

    try {
      DualResult? result = await instance.address.info(id: id);

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(
            current: AddressStatus.success,
            status: result?.status,
            address: result?.model));
      } else {
        emit(state.copyWith(
            current: AddressStatus.failure, status: result?.status));
      }
    } catch (_) {
      emit(state.copyWith(
          current: AddressStatus.failure, status: Protocol.unknownError));
    }
  }
}
