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

part 'order_list.g.dart';

@JsonSerializable()
class OrderList {
  final int id;
  final String address;
  final String city;
  final String zip;
  final int driver;
  final int userid;
  final String orderStatus;
  final String mainStatus;
  final String created;

  const OrderList(
      {required this.userid,
      required this.zip,
      required this.address,
      required this.driver,
      required this.city,
      required this.id,
      required this.orderStatus,
      required this.mainStatus,
      required this.created});
  const OrderList.initial()
      : this(
            driver: 0,
            userid: 0,
            zip: "",
            id: 0,
            address: "",
            city: "",
            orderStatus: "",
            created: "",
            mainStatus: "");

  factory OrderList.fromJson(Map<String, dynamic> json) =>
      _$OrderListFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListToJson(this);
}
