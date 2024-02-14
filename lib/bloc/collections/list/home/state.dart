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

enum ProductCollectionStatus { loading, initial, success, failure }

class ProductCollectionState extends Equatable {
  final ProductCollectionStatus status;
  final bool hasReachedMax;
  final List<Product> products;
  final String name;
  final int id;
  final int total;

  const ProductCollectionState({
    this.status = ProductCollectionStatus.initial,
    this.hasReachedMax = false,
    this.products = const <Product>[],
    this.name = "",
    this.id = 0,
    this.total = 0,
  });

  ProductCollectionState copyWith({
    ProductCollectionStatus? status,
    String? name,
    List<Product>? products,
    bool? hasReachedMax,
    int? total,
    int? id,
  }) {
    return ProductCollectionState(
      name: name ?? this.name,
      id: id ?? this.id,
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, name, total, id];
}
