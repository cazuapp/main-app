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

part of 'address.dart';

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as int,
      address: Name.pure(json['address']),
      name: Name.pure(json['name']),
      city: Name.pure(json['city']),
      zip: Zip.pure(json['zip']),
      options: Optional.pure(json['options']),
      commentary: Optional.pure(json['commentary']),
      createdat: json['createdat'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'city': instance.city,
      'name': instance.name,
      'zip': instance.zip,
      'options': instance.options,
      'commentary': instance.commentary,
      'createdat': instance.createdat
    };
