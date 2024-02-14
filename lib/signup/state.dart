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

class SignupState extends Equatable {
  final FormzSubmissionStatus status;

  final Email email;
  final Name first;
  final Phone phone;
  final Name last;
  final Password password;
  final bool isValid;
  final int result;
  final String errmsg;

  const SignupState({
    this.result = Protocol.empty,
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phone = const Phone.pure(),
    this.first = const Name.pure(),
    this.last = const Name.pure(),
    this.isValid = false,
    this.errmsg = "",
  });

  const SignupState.initial()
      : this(
          result: Protocol.empty,
          status: FormzSubmissionStatus.initial,
          email: const Email.pure(),
          password: const Password.pure(),
          phone: const Phone.pure(),
          first: const Name.pure(),
          last: const Name.pure(),
          isValid: false,
          errmsg: "",
        );

  SignupState copyWith({
    int? result,
    FormzSubmissionStatus? status,
    Email? email,
    Phone? phone,
    Name? first,
    Name? last,
    Password? password,
    bool? isValid,
    String? errmsg,
  }) {
    return SignupState(
        result: result ?? this.result,
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        first: first ?? this.first,
        last: last ?? this.last,
        errmsg: errmsg ?? this.errmsg,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props =>
      [result, status, password, email, errmsg, first, last, phone];
}
