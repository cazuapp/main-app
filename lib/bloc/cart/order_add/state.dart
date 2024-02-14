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

import 'package:cazuapp/models/order.dart';
import 'package:equatable/equatable.dart';

import '../../../core/protocol.dart';

enum OrderStatus { initial, success, failure, loading }

class OrderPlaceState extends Equatable {
  const OrderPlaceState({
    this.errmsg = "",
    this.result = Protocol.empty,
    this.status = OrderStatus.initial,
    this.order = const Order.initial(),
  });

  const OrderPlaceState.initial() : this(errmsg: "", result: Protocol.empty);

  final OrderStatus status;

  final int result;
  final Order order;
  final String errmsg;

  OrderPlaceState copyWith({
    int? result,
    String? errmsg,
    Order? order,
    OrderStatus? status,
  }) {
    return OrderPlaceState(
        status: status ?? this.status,
        order: order ?? this.order,
        errmsg: errmsg ?? this.errmsg,
        result: result ?? this.result);
  }

  @override
  List<Object> get props => [errmsg, result, status];
}
