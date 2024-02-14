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

import 'package:cazuapp/validators/phone.dart';
import 'package:cazuapp/validators/phone_code.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../components/request.dart';
import '../../../core/protocol.dart';
import '../../../validators/lang.dart';
import '../../../validators/name.dart';

import '../../../src/cazuapp.dart';
import '../../../validators/email.dart';

part 'event.dart';
part 'state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final AppInstance instance;

  UserInfoBloc({required this.instance})
      : super(const UserInfoState.initial()) {
    on<UsersInfoBlocKeyChanged>(_onKeyChanged);
    on<LoadBase>(_onLoadBase);
    on<UsersInfoEventOK>(_onOK);
    on<UsersInfoSubmitted>(_onSubmitted);
    on<UserProgress>(_onUserProgress);
    on<UsersInfoPreloadChanged>(_onPreload);
    on<UsersFetchHealth>(_onHealth);
  }

  Future<void> _onLoadBase(LoadBase event, Emitter<UserInfoState> emit) async {
    await instance.setup();
  }

  Future<void> _onHealth(
      UsersFetchHealth event, Emitter<UserInfoState> emit) async {
    await instance.auth.getholds();
  }

  Future<void> _onUserProgress(
      UserProgress event, Emitter<UserInfoState> emit) async {
    final value = event.value;

    emit(state.copyWith(
        value: value, isValid: false, status: FormzSubmissionStatus.initial));
  }

  void _onOK(UsersInfoEventOK event, Emitter<UserInfoState> emit) {
    emit(const UserInfoState.initial());
  }

  Future<void> _onPreload(
      UsersInfoPreloadChanged event, Emitter<UserInfoState> emit) async {
    final key = event.key;
    final value = event.value;
    final icon = event.iconsrc;

    emit(state.copyWith(iconsrc: icon, key: key, value: value, isValid: false));
  }

  void _onKeyChanged(
      UsersInfoBlocKeyChanged event, Emitter<UserInfoState> emit) {
    final key = state.key;
    dynamic value;

    switch (key) {
      case LocalKeyEvent.email:
        {
          value = Email.dirty(event.value);
        }

        break;

      case LocalKeyEvent.first:
        {
          value = Name.dirty(event.value);
        }

        break;

      case LocalKeyEvent.last:
        {
          value = Name.dirty(event.value);
        }

        break;

      case LocalKeyEvent.phone:
        {
          value = Phone.dirty(event.value);
        }

        break;

      case LocalKeyEvent.phonecode:
        {
          value = PhoneCode.dirty(event.value);
        }

        break;

      case LocalKeyEvent.lang:
        {
          value = Lang.dirty(event.value);
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
      UsersInfoSubmitted event, Emitter<UserInfoState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        if (state.finalvalue.isEmpty) {
          emit(state.copyWith(
              result: Protocol.noChange,
              status: FormzSubmissionStatus.failure));
          return;
        }

        int? result =
            await instance.auth.update(key: state.key, value: state.finalvalue);
        String? errmsg = "Error while processing request";

        switch (state.result) {
          case Protocol.emailExists:
            errmsg = "Email exists";
            break;

          case Protocol.noInternet:
            errmsg = "No internet.";
            break;

          case Protocol.noChange:
            errmsg = "No change";
            break;

          default:
            errmsg = "Error occured";
            break;
        }

        if (result == Protocol.ok) {
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
