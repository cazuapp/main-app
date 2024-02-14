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
import '../components/request.dart';
import '../core/routes.dart';
import '../models/address.dart';
import '../models/queryresult.dart';

class AddressManager {
  AppInstance instance;

  int total;

  AddressManager({required this.instance}) : total = 0;

  /* resets addresses within your stack */

  Future<void> reset() async {}

  /*
  * delete(): Deletes an address.
  * 
  * @return
  * 
  *          · protocol.ok: Address removed.
  *
  * @error
  *
  *          · unknownError: Unknown error occured.
  */

  Future<int?> delete({required int id}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.appDelete, body: {"id": id});

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    total = 0;
    return Protocol.ok;
  }

  /*
  * info(): Information about an address.
  * 
  * @return
  * 
  *          · DualResult: Result containing both returning status an
  *                        address.
  *
  * @error
  *
  *          · unknownError: Unknown error occured.
  */

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.addressInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];

    return DualResult(model: Address.fromJson(data), status: Protocol.ok);
  }

  /*
    * add(): Adds a new address.
    * 
    * @return
    * 
    *          · protocol.ok: Address added.
    *
    * @error
    *
    *          · unknownError: Unknown error occured.
    */

  Future<int?> add(
      {required String name,
      required String address,
      String? commentary,
      String? zip,
      String? city,
      String? options}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.addressAdd, body: {
      "name": name,
      "address": address,
      "zip": zip,
      "city": city,
      "options": options,
      "commentary": commentary
    });

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    return Protocol.ok;
  }

  Future<void> init() async {}

  /*
    * suggest(): Suggests a default address to associate new order with.
    * 
    * @return
    * 
    *          · address: Latest address.
    *
    * @error
    *
    *          · result.errors: List of errors.
    */

  Future<int?> getDefault() async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.addressgetDefault, body: {});

    if (!result!.ok()) {
      return result.geterror();
    }

    var data = result.data["data"];

    int? address = data["address_default"];

    return address!;
  }

  /*
    * update(): Updates an address' details.
    * 
    * @return
    * 
    *          · Protocol
    *
    * @error
    *
    *          · result.errors: List of errors.
    */

  Future<int?> update(
      {required int id,
      required LocalKeyEvent key,
      required String value}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.addressUpdate,
        body: {"id": id, key.toShortString(): value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  /*
    * get(): Retrieves a list of addresses.
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
        destination: AppRoutes.addressGet,
        body: {"offset": offset, "limit": limit});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    List<Address> addresses = <Address>[];

    total = result.data["counter"];

    var data = result.data["data"];

    for (var key in data) {
      Address item = Address.fromJson(key);
      addresses.add(item);
    }

    return DualResult(model: addresses, status: Protocol.ok, model2: total);
  }
}
