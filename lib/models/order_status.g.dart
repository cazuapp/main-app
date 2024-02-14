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

part of 'order_status.dart';

OrderStatus _$OrderStatusFromJson(Map<String, dynamic> json) => OrderStatus(
    total: json['total'].toDouble(),
    totalTax: json['total_tax'].toDouble(),
    shipping: json['shipping'].toDouble(),
    totalTaxShipping: json['total_tax_shipping'].toDouble(),
    status: json['order_status'] ?? "",
    orderStatusCode: json['order_status_code'] ?? 0,
    paymentType: json['payment_type'] ?? 0,
    driver: json['order_deliver_driver'] ?? 0);

Map<String, dynamic> _$OrderStatusToJson(OrderStatus instance) =>
    <String, dynamic>{'total': instance.total, 'totalTax': instance.totalTax};
