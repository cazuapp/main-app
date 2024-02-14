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

import 'package:cazuapp/models/variant.dart';
import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/product.dart';
import '../models/queryresult.dart';

class ProductManager {
  AppInstance instance;

  ProductManager({required this.instance});

  Future<void> init() async {}

  /*
   * info(): Information about a product.
   * 
   * @return (DualResult):
   * 
   *          · Product: Product model's data. 
   *          · List<Variant>: Variants found.
   *          · isFavorite: Boolean indicating whether item is favorite or not.
   *
   * @error (DualResult):
   *
   *          · [Error]: error list.
   */

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.productsInfo, body: {"id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"][0];

    int isFavorite = result.data["favorite"];

    DualResult? variantRes = await getvariants(product: id);

    List<Variant> variants = variantRes?.model;

    if (variants.isEmpty) {
      return DualResult(status: Protocol.notFound);
    }

    return DualResult(
        model: Product.fromJson(data),
        model2: variants,
        model3: isFavorite,
        status: Protocol.ok);
  }

  Future<DualResult?> search(
      {int offset = 0,
      int limit = 10,
      required String value,
      required int id}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.collectionsSearchProducts,
        body: {"offset": offset, "limit": limit, "value": value, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Product> products = <Product>[];

    var data = result.data["data"];

    for (var key in data) {
      Product product = Product.fromJson(key);
      products.add(product);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: products, model2: total);
  }

  /*
    * get(): Retrieves a list of products.
    * 
    * @return (DualResult):
    * 
    *          · Protocol.ok: List returned properly.
    *          · List<Product>: Product list.
    *          · int: Total product list (counter).
    *
    * @error
    *
    *          · [Error]: List of errors.
    */

  Future<DualResult?> get(
      {int offset = 0, int limit = 10, int collection = 1}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.collectionsProducts,
        body: {"offset": offset, "limit": limit, "id": collection});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Product> products = <Product>[];

    var data = result.data["data"];

    for (var key in data) {
      Product product = Product.fromJson(key);
      products.add(product);
    }

    int total = result.data["counter"];

    return DualResult(status: Protocol.ok, model: products, model2: total);
  }

  /*
    * getvariants(): Retrieves a list of variants.
    * 
    * @return
    * 
    *          · Protocol
    *
    * @error
    *
    *          · result.errors: List of errors.
    */

  Future<DualResult?> getvariants(
      {int offset = 0, int limit = 10, int product = 0}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.variantsGet,
        body: {"offset": offset, "limit": limit, "id": product});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Variant> variants = <Variant>[];

    var data = result.data["data"];

    for (var key in data) {
      Variant variant = Variant.fromJson(key);
      variants.add(variant);
    }

    return DualResult(status: Protocol.ok, model: variants);
  }
}
