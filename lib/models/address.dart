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

import '../validators/name.dart';
import '../validators/optional.dart';
import '../validators/zip.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final int id;
  final Name address;
  final Name name;

  final Name city;
  final Zip zip;
  final Optional options;
  final Optional commentary;

  final String createdat;

  const Address(
      {required this.id,
      required this.address,
      required this.name,
      required this.city,
      required this.zip,
      required this.options,
      required this.commentary,
      required this.createdat});

  const Address.initial()
      : this(
            address: const Name.pure(),
            createdat: "",
            name: const Name.pure(),
            city: const Name.pure(),
            zip: const Zip.pure(),
            commentary: const Optional.pure(),
            options: const Optional.pure(),
            id: 0);

  Address copyWith(
      {String? createdat,
      Name? name,
      int? id,
      Name? address,
      Name? city,
      Zip? zip,
      Optional? options,
      Optional? commentary}) {
    return Address(
        createdat: createdat ?? this.createdat,
        address: address ?? this.address,
        name: name ?? this.name,
        id: id ?? this.id,
        city: city ?? this.city,
        zip: zip ?? this.zip,
        options: options ?? this.options,
        commentary: commentary ?? this.commentary);
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
