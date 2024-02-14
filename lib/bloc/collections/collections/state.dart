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

enum CollectionStatus { initial, success, failure, loading }

class CollectionState extends Equatable {
  const CollectionState({
    this.status = CollectionStatus.initial,
    this.collections = const <Collection>[],
    this.hasReachedMax = false,
    this.total = 0,
  });

  final CollectionStatus status;
  final List<Collection> collections;
  final bool hasReachedMax;
  final int total;

  CollectionState copyWith({
    CollectionStatus? status,
    List<Collection>? collections,
    bool? hasReachedMax,
    int? total,
  }) {
    return CollectionState(
      status: status ?? this.status,
      total: total ?? this.total,
      collections: collections ?? this.collections,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''CollectionState { status: $status, hasReachedMax: $hasReachedMax, posts: ${collections.length} }''';
  }

  @override
  List<Object> get props => [status, collections, hasReachedMax, total];
}
