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

enum OrderStatus { initial, loading, success, failure, cancelsuccess }

class OrderManagerState extends Equatable {
  const OrderManagerState(
      {required this.errmsg,
      required this.status,
      this.id = 0,
      this.current = OrderStatus.initial,
      this.info = const OrderInfo.initial()});

  const OrderManagerState.initial()
      : this(
            id: 0,
            errmsg: "",
            status: Protocol.empty,
            current: OrderStatus.initial,
            info: const OrderInfo.initial());

  final OrderInfo info;
  final int status;
  final int id;
  final OrderStatus current;
  final String errmsg;

  OrderManagerState copyWith(
      {int? id,
      String? errmsg,
      int? status,
      required current,
      OrderInfo? info}) {
    return OrderManagerState(
        id: id ?? this.id,
        errmsg: errmsg ?? this.errmsg,
        status: status ?? this.status,
        current: current ?? this.current,
        info: info ?? this.info);
  }

  @override
  List<Object> get props => [errmsg, status, current, info];
}
