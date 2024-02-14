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

import 'dart:developer';

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class OrderManagerBloc extends Bloc<OrderManagerEvent, OrderManagerState> {
  final AppInstance instance;

  OrderManagerBloc({required this.instance})
      : super(const OrderManagerState.initial()) {
    on<OrderCancelEventOK>(_onOK);
    on<OrderCancelRequest>(_onCancelRequest);
    on<OrderInfoRequest>(_onInfoRequest);
  }

  void _onOK(OrderCancelEventOK event, Emitter<OrderManagerState> emit) {
    emit(const OrderManagerState.initial());
  }

  Future<void> _onInfoRequest(
      OrderInfoRequest event, Emitter<OrderManagerState> emit) async {
    final id = event.id;

    log("Requesting order information id on $id");

    emit(state.copyWith(current: OrderStatus.loading));
    String? errmsg = "Error while processing request";

    try {
      DualResult? result = await instance.orders.info(id: id);

      switch (result?.status) {
        case Protocol.empty:
          errmsg = "Unable to locate order";
          break;

        case Protocol.invalidParam:
          errmsg = "Unable to locate order";
          break;
      }

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(
            status: Protocol.ok,
            current: OrderStatus.success,
            info: result?.model));
      } else {
        emit(state.copyWith(
            status: result?.status,
            errmsg: errmsg,
            current: OrderStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(
          status: Protocol.unknownError, current: OrderStatus.failure));
    }
  }

  Future<void> _onCancelRequest(
      OrderCancelRequest event, Emitter<OrderManagerState> emit) async {
    final int id = event.id;

    emit(state.copyWith(current: OrderStatus.loading));

    String? errmsg = "Error while processing request";

    try {
      int? result = await instance.orders.cancel(id: id);

      switch (result) {
        case Protocol.empty:
          errmsg = "Unable to locate order";
          break;

        case Protocol.invalidParam:
          errmsg = "Unable to locate order";
          break;
      }

      if (result == Protocol.ok) {
        emit(
            state.copyWith(status: result, current: OrderStatus.cancelsuccess));
      } else {
        emit(state.copyWith(
            status: result, errmsg: errmsg, current: OrderStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(
          status: Protocol.unknownError, current: "Unknown error"));
    }
  }
}
