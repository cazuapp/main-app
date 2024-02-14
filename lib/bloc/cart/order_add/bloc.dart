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

import 'package:cazuapp/bloc/cart/order_add/state.dart';
import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/core/protocol.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';

class OrderAddBloc extends Bloc<PlaceOrderEvent, OrderPlaceState> {
  final AppInstance instance;

  OrderAddBloc({required this.instance})
      : super(const OrderPlaceState.initial()) {
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event, Emitter<OrderPlaceState> emit) async {
    final int address = event.address;
    final int payment = event.payment;

    emit(state.copyWith(status: OrderStatus.loading));

    List? json = await instance.cart.asJson();

    DualResult? result = await instance.orders
        .add(format: json, address: address, payment: payment);

    if (result?.status == Protocol.ok) {
      log("Order placed successfuly!");

      await instance.cart.reset();
      emit(state.copyWith(order: result?.model, status: OrderStatus.success));

      return;
    } else {
      emit(state.copyWith(status: OrderStatus.failure));
    }
  }
}
