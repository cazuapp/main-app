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

part of 'bloc.dart';

class ForgotAheadState extends Equatable {
  final FormzSubmissionStatus status;
  final int? result;
  final Forgot code;
  final Password password;
  final Password password2;
  final Email email;
  final bool isValid;
  final String errmsg;

  const ForgotAheadState({
    this.status = FormzSubmissionStatus.initial,
    this.result = Protocol.empty,
    this.code = const Forgot.dirty(),
    this.password = const Password.dirty(),
    this.password2 = const Password.dirty(),
    this.email = const Email.dirty(),
    this.isValid = false,
    this.errmsg = "",
  });

  ForgotAheadState copyWith({
    FormzSubmissionStatus? status,
    int? result,
    bool? isValid,
    Email? email,
    Forgot? code,
    Password? password,
    Password? password2,
    String? errmsg,
  }) {
    return ForgotAheadState(
      result: result ?? this.result,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      errmsg: errmsg ?? this.errmsg,
      status: status ?? this.status,
      code: code ?? this.code,
      password: password ?? this.password,
      password2: password2 ?? this.password2,
    );
  }

  @override
  List<Object> get props =>
      [errmsg, status, code, password, email, password2, isValid, result!];
}
