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

import '../components/etc.dart';

class Collection extends Equatable {
  /* Unique collection ID, as assigned by the REST SQL database. */

  final int id;
  final String title;
  final String imagesrc;

  const Collection(
      {required this.id, required this.title, required this.imagesrc});

  factory Collection.fromJson(Map<dynamic, dynamic> json) {
    return Collection(
        id: json['id'],
        title: json['title'],
        imagesrc: Etc.makepublic(destination: json['imagesrc']));
  }

  Map<dynamic, dynamic> toJson(Collection instance) => <dynamic, dynamic>{
        'id': instance.id,
        'title': instance.title,
        'imagesrc': instance.imagesrc,
      };

  @override
  List<Object> get props => [id, title, imagesrc];

  @override
  String toString() =>
      'Collection { id: $id, title: $title, imagesrc: $imagesrc }';
}
