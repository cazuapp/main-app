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

part of 'first_ping.dart';

FirstPing _$FirstPingFromJson(Map<String, dynamic> json) => FirstPing(
    latest: json['latest'] as String,
    url: json['url'] ?? "",
    online: json['online'] as bool,
    use: json['use'] as String,
    maint: json['maint'] as bool,
    orders: json['orders'] as bool);

Map<String, dynamic> _$FirstPingToJson(FirstPing instance) => <String, dynamic>{
      'latest': instance.latest,
      'url': instance.url,
      'online': instance.online,
      'use': instance.use,
      'maint': instance.maint,
      'orders': instance.orders
    };
