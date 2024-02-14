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

part of 'user_info.dart';

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
    id: json['id'] ?? 0,
    first: json['first'] ?? "",
    last: json['last'] ?? "",
    phone: json['phone'] ?? "");

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) =>
    <String, dynamic>{'first': instance.first, 'last': instance.last};
