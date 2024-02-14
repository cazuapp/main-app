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

class PasswdState extends Equatable {
  final FormzSubmissionStatus status;
  final Password current;
  final Password newpass;
  final Password newpass2;
  final int result;
  final String errmsg;
  final String okmsg;

  final bool isValid;

  const PasswdState(
      {required this.status,
      required this.result,
      required this.errmsg,
      required this.okmsg,
      required this.current,
      required this.newpass,
      required this.newpass2,
      required this.isValid});

  const PasswdState.initial()
      : this(
            status: FormzSubmissionStatus.initial,
            result: Protocol.empty,
            errmsg: "",
            okmsg: "",
            current: const Password.pure(),
            newpass: const Password.pure(),
            newpass2: const Password.pure(),
            isValid: false);

  PasswdState copyWith({
    FormzSubmissionStatus? status,
    int? result,
    String? errmsg,
    String? okmsg,
    Password? current,
    Password? newpass,
    Password? newpass2,
    bool? isValid,
  }) {
    return PasswdState(
        result: result ?? this.result,
        errmsg: errmsg ?? this.errmsg,
        current: current ?? this.current,
        okmsg: okmsg ?? this.okmsg,
        status: status ?? this.status,
        newpass: newpass ?? this.newpass,
        newpass2: newpass2 ?? this.newpass2,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props =>
      [result, okmsg, errmsg, status, current, newpass, newpass2];
}
