/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'package:cazuapp/components/etc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_list.g.dart';

@JsonSerializable()
class ProductListItem {
  final int id;
  final int collection;
  final double price;
  final String description;
  final String image;
  final String name;
  final String created;
  final String collectionTitle;

  const ProductListItem({
    required this.id,
    required this.collection,
    required this.price,
    required this.description,
    required this.image,
    required this.name,
    required this.created,
    required this.collectionTitle,
  });

  const ProductListItem.initial()
      : this(
            id: 0,
            collection: 0,
            price: 0.0,
            description: "",
            image: "",
            name: "",
            created: "",
            collectionTitle: "");

  factory ProductListItem.fromJson(Map<String, dynamic> json) =>
      _$ProductListItemListFromJson(json);
}
