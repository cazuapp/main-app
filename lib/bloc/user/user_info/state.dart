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

class UserInfoState extends Equatable {
  final FormzSubmissionStatus status;

  final LocalKeyEvent key;
  final String value;
  final String finalvalue;
  final bool isValid;
  final int result;
  final String errmsg;
  final String okmsg;
  final IconData iconsrc;

  const UserInfoState.initial()
      : this(
          errmsg: "",
          okmsg: "",
          key: LocalKeyEvent.empty,
          value: "",
          finalvalue: "",
          iconsrc: Icons.perm_identity,
          result: Protocol.empty,
          status: FormzSubmissionStatus.initial,
          isValid: false,
        );

  const UserInfoState({
    required this.errmsg,
    required this.okmsg,
    required this.key,
    required this.value,
    required this.finalvalue,
    required this.iconsrc,
    required this.result,
    required this.status,
    required this.isValid,
  });

  UserInfoState copyWith({
    int? result,
    String? errmsg,
    String? okmsg,
    FormzSubmissionStatus? status,
    LocalKeyEvent? key,
    String? value,
    IconData? iconsrc,
    String? finalvalue,
    bool? isValid,
  }) {
    return UserInfoState(
        result: result ?? this.result,
        iconsrc: iconsrc ?? this.iconsrc,
        key: key ?? this.key,
        errmsg: errmsg ?? this.errmsg,
        okmsg: okmsg ?? this.okmsg,
        value: value ?? this.value,
        finalvalue: finalvalue ?? this.finalvalue,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props =>
      [okmsg, key, errmsg, value, status, finalvalue, iconsrc];
}
