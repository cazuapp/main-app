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

enum ProductSearchStatus { loading, initial, success, failure }

class ProductCollectionSearchState extends Equatable {
  final ProductSearchStatus status;
  final bool hasReachedMax;
  final List<Product> products;
  final int total;
  final String text;
  final String name;
  final int id;

  const ProductCollectionSearchState({
    this.status = ProductSearchStatus.initial,
    this.hasReachedMax = false,
    this.products = const <Product>[],
    this.total = 0,
    this.id = 0,
    this.name = '',
    this.text = '',
  });

  ProductCollectionSearchState copyWith({
    String? text,
    ProductSearchStatus? status,
    int? total,
    int? id,
    String? name,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductCollectionSearchState(
      text: text ?? this.text,
      status: status ?? this.status,
      name: name ?? this.name,
      total: total ?? this.total,
      id: id ?? this.id,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props =>
      [status, products, total, hasReachedMax, text, id, name];
}
