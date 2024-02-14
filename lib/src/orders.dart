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

import 'dart:developer';

import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/item.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:cazuapp/models/order_list.dart';
import 'package:cazuapp/src/cazuapp.dart';

import '../components/dual.dart';
import '../core/protocol.dart';
import '../components/request.dart';
import '../models/order.dart';
import '../models/queryresult.dart';

enum LastRequest { pending, nodriver, active, cancelled, empty }

extension ParseKeyToString on LastRequest {
  String toShortString() {
    return toString().split('.').last;
  }
}

class OrdersManager {
  String last = "empty";
  AppInstance instance;

  OrdersManager({required this.instance});

  Future<void> init() async {}

  /*
  * cancel(): Cancels an order. This function will update the orders' current order_status to 'cancelled'.
  * 
  * @return:
  * 
  *          · Protocol.ok: Order has been cancelled.
  *
  * @error:
  *
  *          · Protocol.unknownError: Unknown error occured.
  */

  Future<int?> cancel({required int id}) async {
    log("Cancelling order $id");

    QueryResult? result = await instance.query
        .run(destination: AppRoutes.orderCancel, body: {"id": id});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  /*
   * add(): Adds a new order into the system. A new order will automatically have the 'pending' status within order_status.
   * 
   * @return (DualResult):
   * 
   *          · Protocol.ok: Order added.
   *          · model: Added order.
   *
   * @error (DualResult):
   *
   *          · [Errors]: Unable to add order.
   */

  Future<DualResult?> add(
      {required List format,
      required int address,
      required int payment}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.addOrder,
        body: {"payment": payment, "address": address, "items": format});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    Order order = Order.fromJson(data);

    return DualResult(status: Protocol.ok, model: order);
  }

  /*
    * getItems(): Gets items associated with an order.
    * 
    * @return (DualResult):
    * 
    *          · Protocol.ok: Items retrieved successfuly.
    *          · List<Item>: Contains requested items.
    *
    * @error (DualResult):
    *
    *          · [Errors]: Contains protocol error message.
    */

  Future<DualResult?> getItems(
      {int offset = 0, int limit = 10, int id = 0}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.getItems,
        body: {"offset": offset, "limit": limit, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var counter = result.data["data"]["count"];
    var data = result.data["data"]["rows"];

    List<Item> items = <Item>[];

    for (var key in data) {
      Item order = Item.fromJson(key);
      items.add(order);
    }

    return DualResult(status: Protocol.ok, model: items, model2: counter);
  }

  /*
    * get(): Gets orders within a range.
    * 
    * @return (DualResult):
    * 
    *          · List<OrderList>: Contains requested orders.
    *
    * @error (DualResult):
    *
    *          · [Error]: Contains protocol error message.
    */

  Future<DualResult?> get(
      {int offset = 0, int limit = 10, String? param}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.orderGetBy,
        body: {"param": param, "offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  /*
    * products(): Retrieves list of products associated with order.
    * 
    * @return (DualResult):
    * 
    *          · Protocol.ok: Products successfuly retrieved.
    *          · List<Order>: Product list.
    *
    * @error (DualResult):
    *
    *          · DualResult contaning result.errors, which is a list of errors.
    */

  Future<DualResult?> products(
      {int offset = 0, int limit = 10, required int id}) async {
    QueryResult? result = await instance.query.run(
        type: RequestType.post,
        destination: 'app/orders/get',
        body: {"id": id, "offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    List<Order> orders = <Order>[];

    for (var key in data) {
      Order order = Order.fromJson(key);
      orders.add(order);
    }

    return DualResult(status: Protocol.ok, model: orders);
  }

  /*
  * info(): Information about an order.
  * 
  * @return (DualResult):
  * 
  *          · OrderInfo: Information about order.
  *
  * @error (DualResult):
  *
  *          · [Error]: Error list.
  */

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.orderInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    OrderInfo order = OrderInfo.fromJson(data);

    return DualResult(model: order, status: Protocol.ok);
  }
}
