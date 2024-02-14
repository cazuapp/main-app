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

import '../components/etc.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final int collection;

  final String image;
  final String name;
  final String description;
  final double price;

  const Product(
      {required this.description,
      required this.id,
      required this.image,
      required this.collection,
      required this.name,
      required this.price});

  const Product.initial()
      : this(
            description: "",
            id: 0,
            image: "",
            collection: 0,
            name: "",
            price: 0.0);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
