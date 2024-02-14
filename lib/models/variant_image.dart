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

part 'variant_image.g.dart';

@JsonSerializable()
class VariantImage {
  final int id;
  final String image;

  VariantImage({required this.id, required this.image});

  VariantImage.initial() : this(id: 0, image: "");

  factory VariantImage.fromJson(Map<String, dynamic> json) =>
      _$VariantImageFromJson(json);

  Map<String, dynamic> toJson() => _$VariantImageToJson(this);
}
