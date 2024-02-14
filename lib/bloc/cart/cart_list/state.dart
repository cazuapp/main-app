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

enum CartListStatus { initial, success, failure, loading, reload }

class CartListState extends Equatable {
  const CartListState(
      {this.status = CartListStatus.initial,
      this.items = const <CartItem>[],
      this.hasReachedMax = false,
      this.qty = 0,
      this.counter = 0,
      this.address = 0,
      this.payment = 1,
      this.addressInfo = const Address.initial(),
      this.preorder = const PreOrder.initial()});

  final PreOrder preorder;
  final CartListStatus status;
  final List<CartItem> items;
  final bool hasReachedMax;
  final int qty;
  final int counter;
  final int address;
  final int payment;
  final Address addressInfo;

  CartListState copyWith({
    int? counter,
    Address? addressInfo,
    CartListStatus? status,
    List<CartItem>? items,
    bool? hasReachedMax,
    int? qty,
    int? address,
    PreOrder? preorder,
    int? payment,
  }) {
    return CartListState(
      counter: counter ?? this.counter,
      addressInfo: addressInfo ?? this.addressInfo,
      status: status ?? this.status,
      preorder: preorder ?? this.preorder,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      address: address ?? this.address,
      payment: payment ?? this.payment,
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() {
    return '''CartState { status: $status, hasReachedMax: $hasReachedMax, posts: ${items.length} }''';
  }

  @override
  List<Object> get props =>
      [status, items, counter, addressInfo, hasReachedMax, qty, preorder];
}
