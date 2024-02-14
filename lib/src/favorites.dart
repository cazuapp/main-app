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

import 'package:cazuapp/models/product.dart';
import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/queryresult.dart';

class FavoritesManager {
  AppInstance instance;

  FavoritesManager({required this.instance});

  /* Inits manager */

  Future<void> init() async {}

  /*
    * get(): Retrieves a list of collections.
    * 
    * @return (DualResult):
    * 
    *          · List<Product> 
    *          · int: Total of favorites found.
    *
    * @error
    *
    *          · [Errors]: Error list.
    */

  Future<DualResult?> get({int offset = 0, int limit = 10}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.favoritesGetJoin,
        body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Product> variants = <Product>[];

    var data = result.data["rows"];

    for (var key in data) {
      Product item = Product.fromJson(key);
      variants.add(item);
    }

    var total = result.data["counter"];

    return DualResult(model: variants, status: Protocol.ok, model2: total);
  }

  /*
    * smart(): Removes (if exists) or adds favorite (if not present).
    * 
    * @return (DualResult):
    * 
    *          · Protocol.ok: Favorite item modified.
    *
    * @error (DualResult):
    *
    *          · [Errors]: Error list.
    */

  Future<DualResult?> smart({required int id, required bool status}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.favoritesSmart,
        body: {"id": id, "value": status});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return DualResult(status: Protocol.ok);
  }
}
