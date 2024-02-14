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

import 'package:cazuapp/models/product.dart';
import 'package:cazuapp/models/variant.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final Variant item;
  final Product base;
  final int qty;

  const CartItem(
      {this.qty = 0,
      this.base = const Product.initial(),
      this.item = const Variant.initial()});

  CartItem copyWith({int? qty, Product? base, Variant? item}) {
    return CartItem(
        qty: qty ?? this.qty, base: base ?? this.base, item: item ?? this.item);
  }

  @override
  List<Object> get props => [qty, base, item];
}
