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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/protocol.dart';

import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  final AppInstance instance;

  AppInfoBloc({required this.instance}) : super(const AppInfoState.initial()) {
    on<StatusChange>(onStatusChange);
    on<TapChange>(onTap);
  }

  Future<void> onTap(TapChange event, Emitter<AppInfoState> emit) async {
    //final value = event.value;
    //final location = event.location;
  }

  Future<void> onStatusChange(
      StatusChange event, Emitter<AppInfoState> emit) async {
    //  final status = event.value;
  }
}
