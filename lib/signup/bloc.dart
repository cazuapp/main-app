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

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/validators/phone.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../validators/name.dart';
import '../validators/password.dart';
import '../src/cazuapp.dart';
import '../core/protocol.dart';
import '../validators/email.dart';

part 'event.dart';
part 'state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AppInstance instance;

  SignupBloc({required this.instance}) : super(const SignupState.initial()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupFirstChanged>(_onFirstChanged);
    on<SignupLastChanged>(_onLastChanged);
    on<SignupPhoneChanged>(_onPhoneChanged);

    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupEventOK>(_onOK);
    on<SignupSubmitted>(_onSubmitted);

    on<SignupProgress>(_onSignupProgress);
  }

  void _onSignupProgress(SignupProgress event, Emitter<SignupState> emit) {
    final email = Email.dirty(event.email);
    final password = Password.dirty(event.password);
    final last = Name.dirty(event.last);
    final first = Name.dirty(event.first);

    emit(state.copyWith(
        first: first,
        last: last,
        password: password,
        email: email,
        isValid: false,
        status: FormzSubmissionStatus.initial));
  }

  void _onOK(SignupEventOK event, Emitter<SignupState> emit) {
    emit(const SignupState.initial());
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email,
        isValid:
            Formz.validate([state.first, state.last, state.password, email])));
  }

  void _onFirstChanged(SignupFirstChanged event, Emitter<SignupState> emit) {
    final first = Name.dirty(event.first);

    emit(state.copyWith(
        first: first,
        isValid:
            Formz.validate([first, state.last, state.password, state.email])));
  }

  void _onPhoneChanged(SignupPhoneChanged event, Emitter<SignupState> emit) {
    final phone = Phone.dirty(event.phone);

    emit(state.copyWith(
        phone: phone,
        isValid: Formz.validate(
            [phone, state.first, state.last, state.password, state.email])));
  }

  void _onLastChanged(SignupLastChanged event, Emitter<SignupState> emit) {
    final last = Name.dirty(event.last);

    emit(state.copyWith(
        last: last,
        isValid:
            Formz.validate([state.first, last, state.password, state.email])));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
        password: password,
        isValid:
            Formz.validate([state.first, state.last, password, state.email])));
  }

  Future<void> _onSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      String? errmsg = "";

      try {
        DualResult? result = await instance.auth.signup(
            //phone: state.phone.value,
            email: state.email.value,
            password: state.password.value,
            first: state.first.value,
            last: state.last.value);

        if (result?.status == Protocol.ok) {
          emit(state.copyWith(
              result: result?.status, status: FormzSubmissionStatus.success));
        } else {
          switch (result?.status) {
            case Protocol.missingEmail:
              errmsg = "Invalid email";
              break;

            case Protocol.emailExists:
              errmsg = "Email already exists";
              break;

            case Protocol.invalidPhone:
              errmsg = "Invalid phone";
              break;

            case Protocol.noInternet:
              errmsg = "No internet";
              break;

            case Protocol.passHasSpaces:
              errmsg = "Password has spaces";
              break;

            case Protocol.invalidLength:
              errmsg = "Invalid pass length";
              break;

            default:
              errmsg = "Registration failure";
          }

          emit(state.copyWith(
              result: result?.status,
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
