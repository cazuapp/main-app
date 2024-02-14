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

/*
 * Main class. AppInstance contains all inits to other classes.
 * This class is in charge of handling other classes and to
 * manipulate data as requested.
 * 
 * AppInstance is singleton and is initialized only once.
 */

import 'dart:developer';
import 'dart:io';

import 'package:cazuapp/core/httpr.dart';
import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/src/address.dart';
import 'package:cazuapp/src/api.dart';
import 'package:cazuapp/src/auth.dart';
import 'package:cazuapp/src/cart.dart';
import 'package:cazuapp/src/collections.dart';
import 'package:cazuapp/src/favorites.dart';

import 'package:cazuapp/src/orders.dart';
import 'package:cazuapp/src/preferences.dart';
import 'package:cazuapp/src/products.dart';
import 'package:cazuapp/src/settings.dart';
import 'package:cazuapp/src/stats.dart';
import 'package:cazuapp/src/tracker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc/user/auth/repository.dart';
import '../components/request.dart';
import '../models/first_ping.dart';
import '../models/queryresult.dart';
import '../models/server.dart';
import '../models/statsdetails.dart';
import '../models/user.dart';
import 'home.dart';

class AppInstance {
  bool geoEnabled = false;

  late FirstPing firstping;
  late StatsDetails statsdetails;

  LocationPermission? permission;

  Position? position;
  late CartManager cart;
  late SettingsManager settings;
  late PreferencesManager preferences;
  late OrdersManager orders;
  late CollectionManager collections;
  late ProductManager products;
  late HomeManager homes;
  late FavoritesManager favorites;
  late TrackerManager tracker;

  late AddressManager address;
  late AuthManager auth;
  late AuthenticationRepository? authenticationRepository;
  late Stats? stats;

  /* Time at which app was installed */

  late String installed;

  /* Operating system this app is running on top of */

  late String os;

  /* O.S's version */

  late String version;

  /* Time at which AppInstance was initialized */

  late DateTime startup;

  late QueryManager query;

  late User _user;
  User get getuser => _user;

  Server? _server;
  Server? get getserver => _server;

  set setuser(User usr) => _user = usr;
  set setserver(Server srv) => _server = srv;

  static final AppInstance instance = AppInstance.build();

  factory AppInstance() {
    return instance;
  }

  Future<void> setup() async {
    log("Running setup..");
    await instance.settings.loadSettings();
    await instance.preferences.loadSettings();
    await instance.auth.stats();
    await instance.auth.getholds();
    log("Init completed");
  }

  Future<void> getlocation() async {
    geoEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  AppInstance.build() {
    _user = User.initial();
    statsdetails = const StatsDetails.initial();
    firstping = FirstPing.initial();
    tracker = TrackerManager(instance: this);
    authenticationRepository = AuthenticationRepository(instance: this);
    preferences = PreferencesManager(instance: this);
    address = AddressManager(instance: this);
    favorites = FavoritesManager(instance: this);
    cart = CartManager(instance: this);
    settings = SettingsManager(instance: this);
    orders = OrdersManager(instance: this);
    products = ProductManager(instance: this);
    homes = HomeManager(instance: this);
    collections = CollectionManager(instance: this);
    auth = AuthManager(instance: this);
    startup = DateTime.now();
    os = Platform.operatingSystem;
    version = Platform.operatingSystemVersion;
    stats = Stats();
    query = QueryManager(instance: this);

    if (kIsWeb) {
      SystemNavigator.pop();
      exit(0);
    }
  }

  Future shutdown() async {
    _user = User.initial();
    _server = null;
  }

  Future init() async {
    log('Initializing instance');
    await dotenv.load(fileName: ".env");
    await getlocation();

    await pingServer();
    await auth.load();

    if (dotenv.env['env'] == "development" &&
        int.parse(dotenv.env['autolog']!) == 1) {
      await instance.auth.login(
          email: dotenv.env['autolog_email'].toString(),
          password: dotenv.env['autolog_password'].toString(),
          doSetup: true,
          remember: true);
    }
  }

  /* 
   * Function: pingServer
   * Returns: Future<bool?>
   * Description: Asynchronously pings the server and performs various checks. 
   */

  Future<bool?> pingServer() async {
    log('First ping');

    /* doLogin basically means that this query does not need to use login token */

    QueryResult? result = await query.run(
        doLogin: false, type: RequestType.get, destination: AppRoutes.initPing);

    if (!result!.ok()) {
      if (result.getStatus() == Httpr.maint) {
        await instance.auth.maint();
      }

      return false;
    }

    var data = result.data["data"];

    firstping = FirstPing.fromJson(data);

    if (firstping.maint == true) {
      log("Server is under maintaince");
      await instance.auth.maint();
      return false;
    }

    return true;
  }
}
