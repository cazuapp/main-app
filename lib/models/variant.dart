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

import 'package:cazuapp/models/variant_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'variant.g.dart';

@JsonSerializable()
class Variant {
  final int id;
  final String title;
  final double price;
  final List<VariantImage> images;

  const Variant(
      {required this.id,
      required this.title,
      required this.price,
      this.images = const <VariantImage>[]});

  const Variant.initial()
      : this(id: 0, title: "", price: 0.0, images: const <VariantImage>[]);

  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);
}
