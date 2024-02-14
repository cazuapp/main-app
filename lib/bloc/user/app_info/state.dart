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

// ignore: camel_case_types
enum tapAction { onTap, tapUp, doubleTapDown, doubleTapCancel, tapDown }

class AppInfoState extends Equatable {
  final int result;
  final String errmsg;
  final String okmsg;

  const AppInfoState.initial()
      : this(
          errmsg: "",
          okmsg: "",
          result: Protocol.empty,
        );

  const AppInfoState({
    required this.errmsg,
    required this.okmsg,
    required this.result,
  });

  AppInfoState copyWith({
    int? result,
    String? errmsg,
    String? okmsg,
  }) {
    return AppInfoState(
        result: result ?? this.result,
        errmsg: errmsg ?? this.errmsg,
        okmsg: okmsg ?? this.okmsg);
  }

  @override
  List<Object> get props => [okmsg, errmsg, result];
}
