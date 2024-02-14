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
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../validators/password.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class PasswdBloc extends Bloc<PasswdEvent, PasswdState> {
  final AppInstance instance;

  PasswdBloc({required this.instance}) : super(const PasswdState.initial()) {
    on<CurrentChanged>(_onCurrentChanged);
    on<NewPassChanged>(_onNewChanged);
    on<NewPass2Changed>(_onNew2Changed);

    on<PasswdEventOK>(_onPasswordEventOK);
    on<PasswdSubmitted>(_onSubmitted);
    on<PasswdProgress>(_onProgress);
  }

  void _onPasswordEventOK(PasswdEventOK event, Emitter<PasswdState> emit) {
    emit(const PasswdState.initial());
  }

  void _onCurrentChanged(CurrentChanged event, Emitter<PasswdState> emit) {
    final current = Password.pure(event.password);
    emit(state.copyWith(
        current: current,
        isValid: Formz.validate([current, state.newpass, state.newpass2])));
  }

  void _onNewChanged(NewPassChanged event, Emitter<PasswdState> emit) {
    final newpass = Password.pure(event.password);
    emit(state.copyWith(
        newpass: newpass,
        isValid: Formz.validate([state.current, newpass, state.newpass2])));
  }

  void _onNew2Changed(NewPass2Changed event, Emitter<PasswdState> emit) {
    final newpass2 = Password.pure(event.password);
    emit(state.copyWith(
        newpass2: newpass2,
        isValid: Formz.validate([newpass2, state.current, state.newpass])));
  }

  void _onProgress(PasswdProgress event, Emitter<PasswdState> emit) {
    emit(state.copyWith(
        isValid: false,
        newpass2: state.newpass2,
        newpass: state.newpass,
        result: Protocol.empty,
        status: FormzSubmissionStatus.initial));
  }

  Future<void> _onSubmitted(
      PasswdSubmitted event, Emitter<PasswdState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        int? result = await instance.auth.passwd(
            email: instance.getuser.email,
            current: state.current.value,
            newpass: state.newpass.value,
            newpass2: state.newpass2.value);
        String? errmsg = "";

        if (result == Protocol.ok) {
          String? okmsg = "Updated";
          emit(state.copyWith(
              result: Protocol.ok,
              okmsg: okmsg,
              status: FormzSubmissionStatus.success));
        } else {
          switch (result) {
            case Protocol.invalidPassword:
              errmsg = "Invalid current password";
              break;

            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            case Protocol.invalidPhone:
              errmsg = "Invalid phone";
              break;

            case Protocol.missmatch:
              errmsg = "Password mismatch";
              break;

            case Protocol.emailExists:
              errmsg = "Email exists";
              break;

            case Protocol.invalidLength:
              errmsg = "Passwords must be 4 chars min.";
              break;

            default:
              errmsg = "Unable to change password";
          }

          emit(state.copyWith(
              result: result,
              errmsg: errmsg,
              status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
