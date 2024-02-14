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
part 'order_info.g.dart';

@JsonSerializable()
class OrderInfo {
  final int id;
  final int address;
  final int driver;
  final String driverFirst;
  final String driverLast;
  final String addressAddress;

  final String addressName;
  final String addressCity;
  final String addressZip;
  final String addressAptsuite;
  final String addressOptions;
  final String addressCommentary;

  final String orderStatus;

  final String deliverStatus;
  final double shipping;
  final double totalTaxShipping;
  final double total;
  final String created;

  const OrderInfo(
      {required this.id,
      required this.addressAddress,
      required this.addressZip,
      required this.addressCity,
      required this.addressAptsuite,
      required this.addressCommentary,
      required this.addressOptions,
      required this.orderStatus,
      required this.address,
      required this.shipping,
      required this.addressName,
      required this.total,
      required this.driverFirst,
      required this.driverLast,
      required this.driver,
      required this.deliverStatus,
      required this.totalTaxShipping,
      required this.created});

  const OrderInfo.initial()
      : this(
            id: 0,
            address: 0,
            addressAddress: "",
            addressCity: "",
            addressAptsuite: "",
            addressOptions: "",
            addressZip: "",
            addressCommentary: "",
            orderStatus: "",
            addressName: "",
            driver: 0,
            shipping: 0.0,
            total: 0.0,
            driverFirst: "",
            driverLast: "",
            deliverStatus: "",
            totalTaxShipping: 0.0,
            created: "");

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInfoToJson(this);
}
