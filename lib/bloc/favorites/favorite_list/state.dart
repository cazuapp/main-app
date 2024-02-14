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

enum FavoriteStatus { initial, success, failure, loading }

class FavoriteState extends Equatable {
  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
    this.total = 0,
  });

  final FavoriteStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final int total;

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
    int? total,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return '''FavoriteState { status: $status, hasReachedMax: $hasReachedMax, posts: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, total];
}
