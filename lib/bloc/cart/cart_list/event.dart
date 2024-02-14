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

class CartListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartListFetch extends CartListEvent {}

class CartFinish extends CartListEvent {}

class CartListReset extends CartListEvent {}

class QuietReset extends CartListEvent {}

class CartListDelete extends CartListEvent {
  CartListDelete(this.item);

  final CartItem item;

  @override
  List<Object> get props => [item];
}

class CartListAdd extends CartListEvent {
  CartListAdd({required this.product, required this.variant});

  final Product product;
  final Variant variant;

  @override
  List<Object> get props => [product, variant];
}

class CartListPre extends CartListEvent {
  CartListPre();

  @override
  List<Object> get props => [];
}

class ResetCounter extends CartListEvent {
  ResetCounter();

  @override
  List<Object> get props => [];
}

class EmptyCart extends CartListEvent {
  EmptyCart();

  @override
  List<Object> get props => [];
}

class CartAddressReload extends CartListEvent {
  CartAddressReload(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class CartGetHolds extends CartListEvent {
  CartGetHolds();

  @override
  List<Object> get props => [];
}

class ResetQty extends CartListEvent {
  ResetQty();

  @override
  List<Object> get props => [];
}

class CartOp extends CartListEvent {
  CartOp({this.op = true});

  final bool op;

  @override
  List<Object> get props => [];
}

class UpdateOp extends CartListEvent {
  UpdateOp({this.op = true, required this.item});

  final bool op;
  final CartItem item;

  @override
  List<Object> get props => [op, item];
}

class SetAddress extends CartListEvent {
  SetAddress({required this.address});

  final int address;

  @override
  List<Object> get props => [address];
}

class SetPrice extends CartListEvent {
  SetPrice({this.price = 0.0});

  final double price;

  @override
  List<Object> get props => [price];
}
