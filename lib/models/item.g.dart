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

part of 'item.dart';

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int,
    variantHistoric: json['variant_historic'] as String,
    total: json['total'].toDouble(),
    quantity: json['quantity'] as int);

Map<String, dynamic> _$ItemToJson(Item instance) =>
    <String, dynamic>{'id': instance.id};
