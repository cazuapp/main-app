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

class StatsDetails extends Equatable {
  final int totalOrders;
  final int totalAddress;
  final double totalSum;
  final int totalFavorites;

  const StatsDetails(
      {required this.totalSum,
      required this.totalFavorites,
      required this.totalAddress,
      required this.totalOrders});

  const StatsDetails.initial()
      : this(totalOrders: 0, totalFavorites: 0, totalAddress: 0, totalSum: 0.0);

  factory StatsDetails.fromJson(Map<dynamic, dynamic> json) {
    return StatsDetails(
      totalOrders: json['total_orders'] ?? 0,
      totalAddress: json['total_address'] ?? 0,
      totalSum: json['total_sum'].toDouble() ?? 0.0,
      totalFavorites: json['total_favorites'] ?? 0,
    );
  }

  @override
  List<Object> get props => [];

  @override
  String toString() => 'StatsDetails {  }';
}
