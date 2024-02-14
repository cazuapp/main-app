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
import 'package:cazuapp/src/cazuapp.dart';

import '../core/protocol.dart';
import '../models/queryresult.dart';

class PreferencesManager {
  AppInstance instance;

  Map<String, String> preferences;

  PreferencesManager({required this.instance})
      : preferences = <String, String>{};

  Future<void> reset() async {
    preferences.clear();
  }

  /*
  * set(): Sets a preference status.
  * 
  *  @parameters:
  *
  *               · key: Preference key to define.
  *               · value: Value to associate key with.
  */

  Future<int?> set({required String key, required String value}) async {
    preferences[key] = value;

    QueryResult? result = await instance.query.run(
        destination: AppRoutes.preferencesSet,
        body: {"key": key, "value": value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  /*
  * loadSettings(): Load settings from preferences.
  *                 This function will define items on the preferences map.
  */

  Future<void> loadSettings() async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.preferencesGetAll);

    if (!result!.ok()) {
      return;
    }

    var data = result.data["data"];

    for (var key in data) {
      preferences[key["key"]] = key["value"];
    }
  }

  /*
  * keyexists(): Whether key exists within system.
  * 
  *  @parameters:
  *
  *               · key: Preference key to check.
  */

  Future<bool?> keyexists({required String key}) async {
    if (preferences.containsKey(key) == true) {
      return true;
    }

    return false;
  }

  /*
  * getValue(): Obtains item from preference map. This function will first verify
  *             whther preference key exists before attempting to return it.
  * 
  *  @parameters:
  *
  *              · key: Preference key to obtain.
  */

  String? getValue({required String key}) {
    if (preferences.containsKey(key) == true) {
      return preferences[key];
    }

    return "";
  }
}
