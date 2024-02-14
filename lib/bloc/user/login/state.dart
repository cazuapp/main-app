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

class LoginState extends Equatable {
  final FormzSubmissionStatus status;
  final int? result;
  final Email email;
  final Password password;
  final bool remember;
  final bool isValid;
  final String errmsg;

  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.result = Protocol.empty,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.remember = false,
    this.isValid = false,
    this.errmsg = "",
  });

  LoginState copyWith({
    FormzSubmissionStatus? status,
    int? result,
    Email? email,
    Password? password,
    bool? remember,
    bool? isValid,
    String? errmsg,
  }) {
    return LoginState(
        result: result ?? this.result,
        errmsg: errmsg ?? this.errmsg,
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        remember: remember ?? this.remember,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props =>
      [errmsg, status, email, isValid, result!, password, remember];
}
