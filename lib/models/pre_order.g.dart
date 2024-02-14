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

part of 'pre_order.dart';

PreOrder _$PreOrderFromJson(Map<String, dynamic> json) => PreOrder(
      total: json['total'].toDouble(),
      totalTax: json['total_tax'].toDouble(),
      shipping: json['shipping'].toDouble(),
      totalTaxShipping: json['total_tax_shipping'].toDouble(),
    );

Map<String, dynamic> _$PreOrderToJson(PreOrder instance) => <String, dynamic>{
      'total': instance.total,
      'shipping': instance.shipping,
      'totalTax': instance.totalTax
    };
