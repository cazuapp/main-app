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

import 'package:cazuapp/validators/password.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../components/dual.dart';
import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';
import '../../../validators/email.dart';
import '../../../validators/forgot_code.dart';

part 'event.dart';
part 'state.dart';

class ForgotAheadBloc extends Bloc<ForgotAheadEvent, ForgotAheadState> {
  final AppInstance instance;

  ForgotAheadBloc({required this.instance}) : super(const ForgotAheadState()) {
    on<ForgotCodeChanged>(_onCodeChanged);
    on<ForgotPasswordChanged>(_onPasswordChanged);
    on<ForgotPassword2Changed>(_onPassword2Changed);
    on<ForgotEmailChanged>(_onEmailChanged);

    on<ForgotEventOK>(_onLoginOK);
    on<ForgotSubmitted>(_onSubmitted);
  }

  void _onLoginOK(ForgotEventOK event, Emitter<ForgotAheadState> emit) {
    emit(const ForgotAheadState());
  }

  void _onEmailChanged(
      ForgotEmailChanged event, Emitter<ForgotAheadState> emit) {
    final email = Email.pure(event.email);

    emit(state.copyWith(
        email: email,
        isValid: Formz.validate(
            [state.password, email, state.code, state.password2])));
  }

  void _onCodeChanged(ForgotCodeChanged event, Emitter<ForgotAheadState> emit) {
    final code = Forgot.dirty(event.code);
    emit(state.copyWith(
        code: code,
        isValid: Formz.validate(
            [code, state.password, state.email, state.password2])));
  }

  void _onPasswordChanged(
      ForgotPasswordChanged event, Emitter<ForgotAheadState> emit) {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
        password: password,
        isValid: Formz.validate(
            [state.email, state.code, password, state.password2])));
  }

  void _onPassword2Changed(
      ForgotPassword2Changed event, Emitter<ForgotAheadState> emit) {
    final password2 = Password.dirty(event.password);

    emit(state.copyWith(
        password2: password2,
        isValid: Formz.validate(
            [state.code, state.password, password2, state.email])));
  }

  Future<void> _onSubmitted(
      ForgotSubmitted event, Emitter<ForgotAheadState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        DualResult? result = await instance.auth.forgotAhead(
            email: state.email.value,
            code: state.code.value,
            password: state.password.value,
            password2: state.password2.value);
        String? errmsg = "";

        if (result?.status == Protocol.ok) {
          emit(state.copyWith(
              result: Protocol.ok, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            case Protocol.unableToLogIn:
              errmsg = "Invalid secret key";
              break;

            case Protocol.missmatch:
              errmsg = "Passwords not matching";
              break;

            default:
              errmsg = "Invalid credentials";
          }

          emit(state.copyWith(
              result: result?.status,
              errmsg: errmsg,
              status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
