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

part of 'bloc.dart';

enum HomeSearchStatus { loading, initial, success, failure }

class HomeSearchState extends Equatable {
  final HomeSearchStatus status;
  final bool hasReachedMax;
  final List<ProductListItem> products;
  final int total;
  final String text;
  final int id;
  final String name;

  const HomeSearchState(
      {this.status = HomeSearchStatus.initial,
      this.hasReachedMax = false,
      this.products = const <ProductListItem>[],
      this.total = 0,
      this.text = '',
      this.id = 0,
      this.name = ''});

  HomeSearchState copyWith({
    String? text,
    HomeSearchStatus? status,
    int? total,
    List<ProductListItem>? products,
    int? id,
    String? name,
    bool? hasReachedMax,
  }) {
    return HomeSearchState(
      text: text ?? this.text,
      status: status ?? this.status,
      total: total ?? this.total,
      products: products ?? this.products,
      id: id ?? this.id,
      name: name ?? this.name,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props =>
      [status, products, total, hasReachedMax, text, name, id];
}
