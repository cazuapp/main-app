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
import 'package:cazuapp/models/product_list.dart';

import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../models/queryresult.dart';

class HomeManager {
  AppInstance instance;

  HomeManager({required this.instance});

  Future<void> reset() async {}

  /*
    * list(): Retrieves list of home items.
    * 
    * @return (DualResult):
    * 
    *          · List<ProductListItem> 
    *          · int: Total of home items found.
    *
    * @error
    *
    *          · [Errors]: Error list.
    */

  Future<DualResult?> list({int offset = 0, int limit = 10, int id = 0}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.homeGet,
        body: {"offset": offset, "limit": limit, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<ProductListItem> products = <ProductListItem>[];

    var data = result.data["data"];

    for (var key in data) {
      ProductListItem item = ProductListItem.fromJson(key);
      products.add(item);
    }

    var counter = result.data["counter"];
    return DualResult(status: Protocol.ok, model: products, model2: counter);
  }

  Future<DualResult?> search(
      {String text = "", int offset = 0, int limit = 10, int id = 0}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.homeSearch,
        body: {"offset": offset, "limit": limit, "id": id, "value": text});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<ProductListItem> products = <ProductListItem>[];

    var data = result.data["data"];

    for (var key in data) {
      ProductListItem item = ProductListItem.fromJson(key);
      products.add(item);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: products, model2: counter);
  }
}
