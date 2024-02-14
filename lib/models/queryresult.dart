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

import '../components/dual.dart';
import '../core/httpr.dart';

class QueryResult {
  /* HTTP status that resulted from this request. */

  int? status;

  /* Data returned in case of success. */

  dynamic data;

  /* List of errors, if any provided. */

  List<int>? errors;

  QueryResult({this.status, required this.errors, this.data});

  QueryResult.initial() : this(data: "", errors: [], status: 0);

  /* Returns first element on error stack */

  int? geterror() {
    return errors![0];
  }

  /* Returns http status */

  int? getStatus() {
    return status;
  }

  /* Returns current error as dual */

  DualResult errorAsDual() {
    return DualResult(status: errors![0], model: null);
  }

  /* Whether query was ok or not */

  bool ok() {
    if (status != Httpr.ok && errors != null && errors!.isNotEmpty) {
      return false;
    }

    return true;
  }

  factory QueryResult.fromJson(int? status, Map<String, dynamic>? json) {
    return QueryResult(
      data: json,
      status: status,
      errors: json?['codes'] != null ? List<int>.from(json?['codes']) : null,
    );
  }

  Map<String, dynamic> toJson(QueryResult instance) => <String, dynamic>{
        'data': instance.data,
        'status': instance.status,
        'errors': instance.errors,
      };
}
