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

enum OrderItemsStatus { initial, success, failure, loading }

class OrderItemsState extends Equatable {
  const OrderItemsState({
    this.status = OrderItemsStatus.initial,
    this.items = const <Item>[],
    this.hasReachedMax = false,
    this.current = const <String>[],
    this.total = 0,
    this.id = 0,
  });

  final List<String> current;
  final OrderItemsStatus status;
  final List<Item> items;
  final bool hasReachedMax;
  final int total;
  final int id;

  OrderItemsState copyWith({
    List<String>? current,
    OrderItemsStatus? status,
    List<Item>? items,
    bool? hasReachedMax,
    int? id,
    int? total,
  }) {
    return OrderItemsState(
      current: current ?? this.current,
      status: status ?? this.status,
      items: items ?? this.items,
      total: total ?? this.total,
      id: id ?? this.id,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''OrderItemsState { status: $status, hasReachedMax: $hasReachedMax, posts: ${items.length} }''';
  }

  @override
  List<Object> get props => [status, items, total, id, hasReachedMax, current];
}
