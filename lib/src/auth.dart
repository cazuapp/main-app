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

import 'package:cazuapp/components/request.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import '../bloc/user/auth/repository.dart';
import '../components/dual.dart';
import '../core/httpr.dart';
import '../core/protocol.dart';
import '../core/routes.dart';
import '../models/first_ping.dart';
import '../models/hold_detail.dart';
import '../models/queryresult.dart';
import '../models/server.dart';
import '../models/statsdetails.dart';
import '../models/user.dart';

class AuthManager {
  AppInstance instance;
  String token = "";
  bool health = true;
  bool ableToOrder = true;

  AuthManager({required this.instance});

  Future<void> init() async {
    health = true;
    ableToOrder = true;
  }

  Future<void> resetdb() async {
    /* Reset all shared preferences data */

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<int?> update(
      {required LocalKeyEvent key, required String value}) async {
    final String keyAsStr = key.toShortString();

    String? target = "app/user/update";

    if (key == LocalKeyEvent.email) {
      target = "app/user/update_email";
    }

    if (value == "") {
      if (instance.getuser.email.isNotEmpty) {
        value = instance.getuser.email;
      } else {
        return Protocol.badFormat;
      }
    }

    QueryResult? result = await instance.query.run(
        devicedata: true,
        type: RequestType.post,
        destination: target,
        body: {keyAsStr: value});

    if (!result!.ok()) {
      return result.geterror();
    }

    return await whoami();
  }

  Future<DualResult?> signup(
      {String phone = "",
      required String email,
      required String password,
      required String first,
      required String last}) async {
    QueryResult? result = await instance.query.run(
        doLogin: false,
        destination: AppRoutes.signup,
        body: {
          "email": email,
          "first": first,
          "last": last,
          "password": password
        });

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    /* will login right after singup */

    return await login(email: email, password: password);
  }

  Future<int?> relogin() async {
    String? aux = instance.auth.token;

    QueryResult? result = await instance.query.run(
        doLogin: false,
        startup: true,
        devicedata: true,
        destination: AppRoutes.extend,
        body: {"auth": aux});

    /* Checks whether re-login failed */

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    token = result.data["extend"]["token"];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String remembers = prefs.getString('login') ?? "";

    if (remembers.isEmpty) {
      await prefs.setString('login', token);
    }

    return Protocol.ok;
  }

  Future<int?> passwd(
      {required String email,
      required String current,
      required String newpass,
      required String newpass2}) async {
    if (newpass != newpass2) {
      return Protocol.missmatch;
    }

    QueryResult? result = await instance.query.run(
        doLogin: false,
        destination: AppRoutes.passwd,
        body: {"email": email, "new": newpass, "password": current});
    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  /*
  * forgot(): Resets an user password' from the system. 
  * 
  * @parameters
  *        
  *          · Email: Email to log user with.

  * 
  * @resolve
  * 
  *          · Protocol
  */

  Future<int?> forgot({required String email}) async {
    QueryResult? result = await instance.query.run(
        doLogin: false,
        startup: true,
        devicedata: true,
        destination: AppRoutes.forgot,
        body: {"email": email});

    /* checks whether login failed */

    if (!result!.ok()) {
      return result.geterror();
    }

    return Protocol.ok;
  }

  /*
  * forgot_ahead(): Resets an user password' from the system. 
  * 
  * @parameters
  *        
  *          · Code: Code to verify against

  * 
  * @resolve
  * 
  *          · Protocol
  */

  Future<DualResult?> forgotAhead(
      {required String email,
      required String code,
      required String password,
      required String password2}) async {
    log("Resseting password for $email");

    if (password != password2) {
      return DualResult(status: Protocol.missmatch);
    }

    QueryResult? result = await instance.query.run(
        doLogin: false,
        destination: AppRoutes.forgotAhead,
        body: {
          "email": email,
          "value": code,
          "password": password,
          "password2": password2
        });

    /* checks whether login failed */

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    return await login(email: email, password: password);
  }

  /*
     * whoami(): Who Am I?
     * 
     * @parameters
     *        
     * 
     * @resolve
     * 
     *          · Protocol
     */

  Future<int?> whoami() async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.whoami, body: {});

    /* checks whether login failed */

    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    await resetall();

    instance.setuser = User.fromJson(result.data["data"]["login"]);

    return Protocol.ok;
  }

  /*
   * login(): Logins an user into the system.
   * 
   * @parameters:
   *        
   *          · Email: Email to log user with.
   *          · Password: Password to utilize.
   *          · Remember: Whether to keep a copy of the login token or not (using sharedPreferences).
   * 
   * @resolve:
   * 
   *          · DualResult: Either returning OK status (protocol.ok) or rejecting the procedure by raising an error state.
   */

  Future<DualResult?> login(
      {required String email,
      required String password,
      bool remember = false,
      bool doSetup = false}) async {
    log('Logging using $email');

    QueryResult? result = await instance.query.run(
        doLogin: false,
        startup: true,
        devicedata: true,
        destination: AppRoutes.login,
        body: {"email": email, "password": password});

    /* checks whether login failed */

    if (!result!.ok()) {
      if (result.geterror() == Protocol.banned) {
        await banned();
        return DualResult.initial();
      }

      return result.errorAsDual();
    }

    token = result.data["login"]["token"];

    /* We keep a copy of the login token if remember param has been provided */

    if (remember) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('login_email', email);
      await prefs.setString('login_password', password);
    }

    if (doSetup) {
      await instance.setup();
    }

    await resetall();

    instance.setserver = Server.fromJson(result.data["server"]);

    instance.setuser = User.fromJson(result.data["login"]);
    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.authenticated);

    return DualResult(status: Protocol.ok);
  }

  Future<void> getholds() async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.holdsGet, body: {});

    if (result?.status == Httpr.ok) {
      health = true;
      ableToOrder = true;

      return;
    }

    var data = result?.data["data"];
    HoldDetail last = HoldDetail.fromJson(data);

    health = last.health;
    ableToOrder = last.ableToOrder;
  }

  /*
   * stats(): Retrieves stats
   * 
   * @modification
   * 
   *          · 
   */

  Future<int?> stats() async {
    QueryResult? result = await instance.query
        .run(type: RequestType.post, destination: 'app/user/stats', body: {});
    if (!result!.ok()) {
      return Protocol.unknownError;
    }

    var data = result.data["data"];
    StatsDetails last = StatsDetails.fromJson(data);
    instance.statsdetails = last;

    return Protocol.ok;
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? login = prefs.getString('login_email');
    final String? loginPassword = prefs.getString('login_password');

    if (login != null && loginPassword != null) {
      await this.login(email: login, password: loginPassword, remember: true);
    }
  }

  Future<void> resetall() async {}

  /*
   * close(): Closes an account.
   * 
   * @resolve
   * 
   *          · protocol.ok: OK closing.
   */

  Future<int?> close() async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.userClose, body: {});

    if (!result!.ok()) {
      return result.geterror();
    }

    await logout();
    return Protocol.ok;
  }

  /* Logouts an user. */

  Future<void> logout({query = true}) async {
    if (!query) {
      await instance.query.run(destination: AppRoutes.userLogout, body: {});
    }

    await clean();

    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.unauthenticated);
  }

/* Sets an user as banned */

  Future<void> banned() async {
    await clean();

    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.banned);
  }

  /*
     * clean(): Resets basic settings
     * 
     * @actions
     *
     *          · clear: Resets shared preferences. 
     *          · Sets user, server, lastlogin and firstping to its initial state.
     *  
     */

  Future<void> clean() async {
    token = "";

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();

    instance.setuser = User.initial();
    instance.setserver = Server.initial();
    instance.firstping = FirstPing.initial();
  }

  Future<void> nointernet() async {
    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.nointernet);
  }

  Future<void> maint() async {
    await clean();
    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.maint);
  }

  Future<void> error({String msg = ""}) async {
    await clean();
    instance.authenticationRepository?.controller
        .add(AuthenticationStatus.error);
  }
}
