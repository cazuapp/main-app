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

part of 'bloc.dart';

enum ProducInfoStatus { initial, loading, success, failure }

class ProductInfoState extends Equatable {
  const ProductInfoState(
      {this.index = 0,
      required this.liked,
      this.display = "",
      required this.dual,
      required this.status,
      this.current = ProducInfoStatus.initial,
      required this.inUse,
      required this.variants});

  ProductInfoState.initial()
      : this(
            index: 0,
            liked: false,
            status: Protocol.empty,
            dual: DualResult.initial(),
            variants: [],
            inUse: const Variant.initial(),
            display: "");

  final DualResult dual;
  final int index;
  final int status;
  final bool liked;
  final ProducInfoStatus current;
  final List<Variant> variants;
  final Variant inUse;
  final String display;

  ProductInfoState copyWith(
      {int? index,
      bool? liked,
      DualResult? dual,
      int? status,
      required current,
      Variant? inUse,
      List<Variant>? variants,
      String? display}) {
    return ProductInfoState(
        index: index ?? this.index,
        display: display ?? this.display,
        dual: dual ?? this.dual,
        status: status ?? this.status,
        liked: liked ?? this.liked,
        current: current ?? this.current,
        variants: variants ?? this.variants,
        inUse: inUse ?? this.inUse);
  }

  @override
  List<Object> get props =>
      [dual, liked, current, status, inUse, variants, display];
}
