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

import 'package:formz/formz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/request.dart';
import '../../../core/protocol.dart';
import '../../../validators/name.dart';
import '../../../src/cazuapp.dart';
import '../../../validators/optional.dart';
import '../../../validators/zip.dart';

part 'event.dart';
part 'state.dart';

class AddressUpdateBloc extends Bloc<AddressInfoEvent, AddressInfoState> {
  final AppInstance instance;

  AddressUpdateBloc({required this.instance})
      : super(const AddressInfoState.initial()) {
    on<AddressUpdateBlocKeyChanged>(_onKeyChanged);

    on<AddressInfoEventOK>(_onOK);
    on<AddresssInfoSubmitted>(_onSubmitted);
    on<AddressProgress>(_onAddressProgress);
    on<AddressUpdatePreloadChanged>(_onPreload);
  }

  Future<void> _onAddressProgress(
      AddressProgress event, Emitter<AddressInfoState> emit) async {
    final value = event.value;

    emit(state.copyWith(
        value: value, isValid: false, status: FormzSubmissionStatus.initial));
  }

  void _onOK(AddressInfoEventOK event, Emitter<AddressInfoState> emit) {
    emit(const AddressInfoState.initial());
  }

  Future<void> _onPreload(
      AddressUpdatePreloadChanged event, Emitter<AddressInfoState> emit) async {
    final key = event.key;
    final id = event.id;
    final value = event.value;
    final icon = event.iconsrc;

    emit(state.copyWith(
        id: id, iconsrc: icon, key: key, value: value, isValid: false));
  }

  void _onKeyChanged(
      AddressUpdateBlocKeyChanged event, Emitter<AddressInfoState> emit) {
    final key = state.key;
    dynamic value;

    switch (key) {
      case LocalKeyEvent.address:
        {
          value = Name.dirty(event.value);
        }

        break;

      case LocalKeyEvent.name:
        {
          value = Name.dirty(event.value);
        }

        break;

      case LocalKeyEvent.city:
        {
          value = Name.dirty(event.value);
        }

        break;

      case LocalKeyEvent.zip:
        {
          value = Zip.dirty(event.value);
        }

        break;

      case LocalKeyEvent.commentary:
        {
          value = Optional.dirty(event.value);
        }
        break;

      case LocalKeyEvent.options:
        {
          value = Optional.dirty(event.value);
        }
        break;

      default:
        {
          return;
        }
    }

    emit(state.copyWith(
        key: key, finalvalue: value.value, isValid: Formz.validate([value])));
  }

  Future<void> _onSubmitted(
      AddresssInfoSubmitted event, Emitter<AddressInfoState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        if (state.finalvalue == "") {
          emit(state.copyWith(
              result: Protocol.ok,
              value: state.value,
              status: FormzSubmissionStatus.success));
          return;
        }

        int? result = await instance.address
            .update(id: state.id, key: state.key, value: state.finalvalue);

        String errmsg = "Error while processing request";

        if (result == Protocol.ok) {
          switch (state.result as dynamic) {
            case Protocol.noChange:
              errmsg = "No change";
              break;

            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            default:
              errmsg = "Error occured";
              break;
          }
          emit(state.copyWith(
              result: result, status: FormzSubmissionStatus.success));
        } else {
          emit(state.copyWith(
              result: result,
              errmsg: errmsg,
              status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(
            result: Protocol.unknownError,
            status: FormzSubmissionStatus.failure));
      }
    }
  }
}
