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

part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    phone: json['phone'],
    first: json['first'],
    last: json['last'],
    email: json['email'],
    verified: json['verified'],
    created: json['created']);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'first': instance.first,
      'last': instance.last,
      'created': instance.created,
      'verified': instance.verified
    };
