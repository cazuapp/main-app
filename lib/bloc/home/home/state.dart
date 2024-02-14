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

enum HomeStatus { loading, initial, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final bool hasReachedMax;
  final List<ProductListItem> products;
  final String text;
  final int total;

  const HomeState({
    this.status = HomeStatus.initial,
    this.hasReachedMax = false,
    this.products = const <ProductListItem>[],
    this.text = "",
    this.total = 0,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? text,
    List<ProductListItem>? products,
    bool? hasReachedMax,
    int? total,
  }) {
    return HomeState(
      text: text ?? this.text,
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
  List<Object> get props => [status, products, hasReachedMax, text, total];
}
