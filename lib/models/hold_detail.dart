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

import 'package:equatable/equatable.dart';

class HoldDetail extends Equatable {
  final bool health;
  final bool ableToOrder;

  const HoldDetail({required this.health, required this.ableToOrder});

  factory HoldDetail.fromJson(Map<dynamic, dynamic> json) {
    return HoldDetail(
        health: json['health'] ?? true,
        ableToOrder: json['able_to_order'] ?? true);
  }

  Map<dynamic, dynamic> toJson(HoldDetail instance) => <dynamic, dynamic>{
        'health': instance.health,
        'ableToOrder': instance.ableToOrder
      };

  @override
  List<Object> get props => [health, ableToOrder];

  @override
  String toString() =>
      'HoldDetail { health: $health, ableToOrder: $ableToOrder }';
}
