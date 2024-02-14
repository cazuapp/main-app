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

enum OrderStatus { initial, success, failure, loading }

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const <OrderList>[],
    this.hasReachedMax = false,
    this.total = 0,
    this.current = const <String>[],
    this.param = "pending",
  });

  final List<String> current;
  final OrderStatus status;
  final List<OrderList> orders;
  final bool hasReachedMax;
  final int total;
  final String param;

  OrderState copyWith({
    List<String>? current,
    OrderStatus? status,
    List<OrderList>? orders,
    bool? hasReachedMax,
    int? total,
    String? param,
  }) {
    return OrderState(
      current: current ?? this.current,
      param: param ?? this.param,
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''OrderState { status: $status, hasReachedMax: $hasReachedMax, posts: ${orders.length} }''';
  }

  @override
  List<Object> get props =>
      [status, orders, hasReachedMax, current, param, total];
}
