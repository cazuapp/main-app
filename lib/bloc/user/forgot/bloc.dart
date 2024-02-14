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
import '../../../src/cazuapp.dart';
import '../../../validators/email.dart';

part 'event.dart';
part 'state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  final AppInstance instance;

  ForgotBloc({required this.instance}) : super(const ForgotState()) {
    on<ForgotEmailChanged>(_onEmailChanged);

    on<ForgotEventOK>(_onLoginOK);
    on<ForgotProgress>(_onLoginProgress);
    on<ForgotSubmitted>(_onSubmitted);
  }

  void _onLoginOK(ForgotEventOK event, Emitter<ForgotState> emit) {
    emit(const ForgotState());
  }

  void _onLoginProgress(ForgotProgress event, Emitter<ForgotState> emit) {
    emit(state.copyWith(
        isValid: false,
        email: state.email,
        result: Protocol.empty,
        status: FormzSubmissionStatus.initial));
  }

  void _onEmailChanged(ForgotEmailChanged event, Emitter<ForgotState> emit) {
    final email = Email.pure(event.email);
    emit(state.copyWith(email: email, isValid: Formz.validate([email])));
  }

  Future<void> _onSubmitted(
      ForgotSubmitted event, Emitter<ForgotState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        int? result = await instance.auth.forgot(email: state.email.value);
        String? errmsg = "";

        if (result == Protocol.ok) {
          emit(state.copyWith(
              result: Protocol.ok, status: FormzSubmissionStatus.success));
        } else {
          switch (result) {
            case Protocol.noInternet:
              errmsg = "No internet.";
              break;

            default:
              errmsg = "Invalid credentials";
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
