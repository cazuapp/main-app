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

import 'package:json_annotation/json_annotation.dart';

part 'pre_order.g.dart';

@JsonSerializable()
class PreOrder {
  final double total;
  final double totalTax;
  final double shipping;
  final double totalTaxShipping;

  const PreOrder(
      {required this.total,
      required this.totalTax,
      required this.shipping,
      required this.totalTaxShipping});

  const PreOrder.initial()
      : this(total: 0.0, totalTax: 0.0, shipping: 0.0, totalTaxShipping: 0.0);

  factory PreOrder.fromJson(Map<String, dynamic> json) =>
      _$PreOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PreOrderToJson(this);
}
