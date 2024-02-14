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

part of 'order_list.dart';

OrderList _$OrderListFromJson(Map<String, dynamic> json) => OrderList(
    id: json['id'] as int,
    userid: json['userid'] ?? 0,
    driver: json['driver'] ?? 0,
    orderStatus: json['order_status'] as String,
    mainStatus: json['deliver_status'] ?? "",
    address: json['address_address'] ?? "",
    zip: json['address_zip'] ?? "",
    city: json['address_city'] ?? "",
    created: json['createdat'] as String);

Map<String, dynamic> _$OrderListToJson(OrderList instance) =>
    <String, dynamic>{'id': instance.id};
