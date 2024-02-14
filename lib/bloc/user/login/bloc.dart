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

part 'event.dart';
part 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AppInstance instance;

  LoginBloc({required this.instance}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginRememberChanged>(_onRememberChanged);
    on<LoginEventOK>(_onLoginOK);
    on<LoginProgress>(_onLoginProgress);

    on<StatsFetch>(_onStatsFetch);

    on<LoginSubmitted>(_onSubmitted);

    on<CloseRequest>(_onCloseRequest);
  }

  Future<void> _onStatsFetch(StatsFetch event, Emitter<LoginState> emit) async {
    await instance.auth.stats();
  }

  void _onLoginOK(LoginEventOK event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }

  void _onLoginProgress(LoginProgress event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        isValid: false,
        email: state.email,
        password: state.password,
        result: Protocol.empty,
        status: FormzSubmissionStatus.initial));
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.pure(event.email);
    emit(state.copyWith(
        email: email, isValid: Formz.validate([state.password, email])));
  }

  void _onRememberChanged(
      LoginRememberChanged event, Emitter<LoginState> emit) {
    final remember = event.remember;
    emit(state.copyWith(remember: remember));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.pure(event.password);

    emit(state.copyWith(
        password: password, isValid: Formz.validate([password, state.email])));
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        DualResult? result = await instance.auth.login(
            email: state.email.value,
            password: state.password.value,
            remember: state.remember,
            doSetup: true);
        String? errmsg = "";

        if (result?.status == Protocol.ok) {
          emit(state.copyWith(
              result: Protocol.ok, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.banned:
              errmsg = "User Banned.";
              break;

            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            case Protocol.pendingOrder:
              errmsg = "You have pending orders";
              break;

            case Protocol.invalidLength:
              errmsg = "Invalid password length";

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

  Future<void> _onCloseRequest(
      CloseRequest event, Emitter<LoginState> emit) async {
    try {
      int? result = await instance.auth.close();

      if (result == Protocol.ok) {
        emit(state.copyWith(result: result));
      } else {
        String? errmsg = "";

        switch (result) {
          case Protocol.pendingOrder:
            errmsg = "You have pending orders";
            break;

          default:
            errmsg = "Closure failure";
        }

        emit(state.copyWith(result: result, errmsg: errmsg));
      }
    } catch (_) {
      emit(state.copyWith(
          result: Protocol.unknownError, errmsg: "Unknown error"));
    }
  }
}
