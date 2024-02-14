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
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;

  /* Email address, also unique. */

  final String email;

  final String phone;

  final String first;

  final String last;

  final String created;

  final int verified;

  const User(
      {required this.id,
      required this.first,
      required this.last,
      required this.email,
      required this.phone,
      required this.created,
      required this.verified});

  User.initial()
      : this(
            id: 0,
            first: "",
            last: "",
            phone: "",
            email: "",
            created: "",
            verified: 0);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
