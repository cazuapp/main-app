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

import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/collection.dart';
import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../models/queryresult.dart';

class CollectionManager {
  AppInstance instance;
  int total;

  CollectionManager({required this.instance}) : total = 0;

  Future<void> init() async {
    await reset();
  }

  Future<void> reset() async {}

  /*
    * get(): Retrieves a list of collections.
    * 
    * @return
    * 
    *          · Protocol
    *
    * @error
    *
    *          · result.errors: List of errors.
    */

  Future<DualResult?> get({int offset = 0, int limit = 10}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.collectionsGet,
        body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Collection> collections = <Collection>[];
    var total = result.data["counter"];

    var data = result.data["data"];

    for (var key in data) {
      Collection collection = Collection.fromJson(key);
      collections.add(collection);
    }

    return DualResult(status: Protocol.ok, model: collections, model2: total);
  }
}
