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

import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/cart_item.dart';
import '../models/pre_order.dart';
import '../models/queryresult.dart';

class CartManager {
  AppInstance instance;

  List<CartItem> items;

  CartManager({required this.instance}) : items = <CartItem>[];

  /* resets items within your stack */

  Future<void> reset() async {
    items.clear();
  }

  /*
  * delete(): Deletes an item.
  * 
  * @return:
  * 
  *          · protocol.ok: Item removed.
  */

  Future<int> delete({required CartItem id}) async {
    items.remove(id);
    return Protocol.ok;
  }

  /*
    * add(): Adds a new item to the cart.
    * 
    * @return
    * 
    *          · protocol.ok: Cart item added.
    */

  Future<int> add({required CartItem item}) async {
    items.add(item);
    return Protocol.ok;
  }

  Future<List> asJson() async {
    var finalFormat = [];

    for (var i = 0; i < items.length; i++) {
      var format = {"variant": items[i].item.id, "quantity": items[i].qty};

      finalFormat.add(format);
    }

    return finalFormat;
  }

  Future<void> checkout() async {}

  Future<void> init() async {}

  /*
   * get(): Retrieves list of items within our cart.
   * 
   * @return:
   * 
   *          · List<CartItem>: List of CartItems. This function will return
   *                            List<CartItem>.empty() if no cart items are found.
   */

  Future<List<CartItem>> get({int offset = 0, int limit = 10}) async {
    if (items.isEmpty) {
      return List<CartItem>.empty();
    }

    return items.skip(offset).take(limit).toList();
  }

  /*
    * preorder(): Simulates a purchase without running it. The purpose of this function
    *             is to receive an estimate of final subtotals, taxes and shipping costs.
    * 
    * @return (DualResult):
    *   
    *             ·  PreOrder: Pre order details (as seen on the models/preorder model file).
    */

  Future<DualResult?> preorder({required List<CartItem> items}) async {
    var variants = [];

    for (var key in items) {
      var aux = {"variant": key.item.id, "quantity": key.qty};
      variants.add(aux);
    }

    QueryResult? result = await instance.query
        .run(destination: AppRoutes.preOrder, body: {"items": variants});

    /* checks whether login failed */

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    return DualResult(model: PreOrder.fromJson(data), status: Protocol.ok);
  }

  Future<int> count() async {
    return items.length;
  }
}
