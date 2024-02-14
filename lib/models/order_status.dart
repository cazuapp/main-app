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

part 'order_status.g.dart';

@JsonSerializable()
class OrderStatus {
  final double total;
  final double totalTax;
  final double shipping;
  final double totalTaxShipping;
  final String status;
  final int paymentType;
  final int driver;
  final int orderStatusCode;

  const OrderStatus(
      {required this.orderStatusCode,
      required this.driver,
      required this.status,
      required this.paymentType,
      required this.total,
      required this.totalTax,
      required this.shipping,
      required this.totalTaxShipping});

  const OrderStatus.initial()
      : this(
            orderStatusCode: 0,
            driver: 0,
            paymentType: 0,
            status: "",
            total: 0.0,
            totalTax: 0.0,
            shipping: 0.0,
            totalTaxShipping: 0.0);

  factory OrderStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}
