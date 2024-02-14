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

part of 'order_info.dart';

OrderInfo _$OrderInfoFromJson(Map<String, dynamic> json) => OrderInfo(
    id: json['id'] as int,
    address: json['address'] as int,
    addressName: json['address_name'] ?? "",
    addressZip: json['address_zip'] ?? "",
    addressCommentary: json['address_commentary'] ?? "",
    addressAptsuite: json['address_aptsuite'] ?? "",
    addressAddress: json['address_address'],
    addressOptions: json['address_options'] ?? "",
    addressCity: json['address_city'] ?? "",
    driver: json['driver'] ?? 0,
    deliverStatus: json['deliver_status'] as String,
    driverFirst: json['driver_first'] ?? "",
    driverLast: json['driver_last'] ?? "",
    created: json['created'] as String,
    orderStatus: json['order_status'] as String,
    shipping: json['shipping'].toDouble(),
    totalTaxShipping: json['total_tax_shipping'].toDouble(),
    total: json['total'].toDouble());

Map<String, dynamic> _$OrderInfoToJson(OrderInfo instance) => <String, dynamic>{
      'id': instance.id,
      'deliverStatus': instance.deliverStatus,
      'created': instance.created
    };
