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
import 'package:cazuapp/src/cazuapp.dart';

import '../models/queryresult.dart';

class SettingsManager {
  AppInstance instance;

  Map<String, String> settings;

  SettingsManager({required this.instance}) : settings = <String, String>{};

  Future<void> reset() async {
    settings.clear();
  }

  Future<void> loadSettings() async {
    log("Loading settings..");
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.settingsGetAll);

    if (!result!.ok()) {
      return;
    }

    var data = result.data["data"];

    for (var key in data) {
      settings[key["key"]] = key["value"];
    }
  }

  Future<bool?> keyexists({required String key}) async {
    if (settings.containsKey(key) == true) {
      return true;
    }

    return false;
  }

  String? getValue({required String key}) {
    if (settings.containsKey(key) == true) {
      return settings[key];
    }

    return "";
  }
}
