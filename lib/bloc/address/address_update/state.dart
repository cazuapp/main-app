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

class AddressInfoState extends Equatable {
  final FormzSubmissionStatus status;
  final int id;
  final LocalKeyEvent key;
  final String value;
  final String finalvalue;
  final String errmsg;
  final bool isValid;
  final int result;
  final IconData iconsrc;

  const AddressInfoState({
    this.id = 0,
    this.key = LocalKeyEvent.empty,
    this.value = "",
    this.errmsg = "",
    this.finalvalue = "",
    this.iconsrc = Icons.perm_identity,
    this.result = Protocol.empty,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  const AddressInfoState.initial()
      : this(
          id: 0,
          key: LocalKeyEvent.empty,
          value: "",
          errmsg: "",
          finalvalue: "",
          iconsrc: Icons.perm_identity,
          result: Protocol.empty,
          status: FormzSubmissionStatus.initial,
          isValid: false,
        );

  AddressInfoState copyWith({
    int? result,
    int? id,
    FormzSubmissionStatus? status,
    LocalKeyEvent? key,
    String? errmsg,
    String? value,
    IconData? iconsrc,
    String? finalvalue,
    bool? isValid,
  }) {
    return AddressInfoState(
        id: id ?? this.id,
        result: result ?? this.result,
        iconsrc: iconsrc ?? this.iconsrc,
        key: key ?? this.key,
        errmsg: errmsg ?? this.errmsg,
        value: value ?? this.value,
        finalvalue: finalvalue ?? this.finalvalue,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [key, errmsg, value, status, finalvalue, iconsrc];
}
