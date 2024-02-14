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

import 'dart:convert';
import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/dual.dart';
import '../core/httpr.dart';
import '../components/request.dart';
import '../core/protocol.dart';
import '../models/queryresult.dart';

class QueryManager {
  AppInstance instance;

  String lasterr = '';

  String startupmsg = '';
  String devicemsg = '';

  QueryManager({required this.instance});

  Future<QueryResult?> run(
      {int override = 0,
      required destination,
      type = RequestType.post,
      Map<String, dynamic>? body,
      bool doLogin = true,
      token = '',
      startup = false,
      FormData? form,
      devicedata = false}) async {
    if (startup == true) {
      startupmsg = instance.startup.toString();
    }

    if (devicedata == true) {
      devicemsg = '${instance.os}/${instance.version}';
    }

/* production queries are sent using base64 encript */

    String? token = "";

    if (dotenv.env['env'].toString() == "production") {
      final bytes = utf8.encode(instance.auth.token);
      token = base64.encode(bytes);
    } else {
      token = instance.auth.token;
    }

    QueryResult? result = await Query(
            destination: destination,
            type: type,
            token: token,
            body: body,
            form: form,
            doLogin: doLogin,
            devicedata: devicemsg,
            version: dotenv.get('version'),
            startup: startupmsg)
        .run();

    if (result?.getStatus() != Httpr.ok) {
      if (result?.getStatus() == Httpr.internetFailed) {
        log("No internet.");
        await instance.auth.nointernet();
        return result;
      }

      if (result?.getStatus() == Httpr.maint) {
        log("Server under maintaince.");
        await instance.auth.maint();
        return QueryResult.initial();
      }

      if (result!.geterror() == Protocol.banned) {
        await instance.auth.banned();
        return QueryResult.initial();
      }

      if (result.geterror() == Protocol.noSecret ||
          result.geterror() == Protocol.invalidSecret) {
        log("An error occured");
        lasterr = "Invalid secret key";
        await instance.auth.error();
        return QueryResult.initial();
      }

      /* No key has provided */

      if (result.geterror() == Protocol.noKeys) {
        log("An unknown error occured");
        lasterr = "Invalid request";
        await instance.auth.error();
        return QueryResult.initial();
      }
    }

    if (result?.getStatus() == Httpr.invalidToken) {
      log('Invalid Token, requesting a new logging.');

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String loginEmail = prefs.getString('login_email') ?? "";
      String loginPassword = prefs.getString('login_password') ?? "";
      String remembers = prefs.getString('login') ?? "";

      bool remember = false;

      if (remembers.isEmpty) {
        remember = true;
      }

      if (loginEmail.isEmpty || loginPassword.isEmpty) {
        log('No email & password found, logging out.');
        await instance.auth.logout();
        return QueryResult.initial();
      }

      log('Creating login call.');

      DualResult? dual = await instance.auth.login(
          email: loginEmail.toString(),
          password: loginPassword.toString(),
          remember: remember,
          doSetup: false);

      if (dual!.status != Protocol.ok) {
        await instance.auth.logout();
        return QueryResult.initial();
      }

      result = await Query(
              destination: destination,
              type: type,
              token: instance.auth.token,
              body: body,
              doLogin: doLogin,
              version: dotenv.get('version'),
              devicedata: devicemsg,
              form: form,
              startup: startupmsg)
          .run();
    }

    if (result?.status == 200) {
      instance.stats?.queries++;
    } else {
      instance.stats?.errors++;
    }

    return result;
  }
}

class Query {
  String destination;
  RequestType type;
  String token = "";
  String startup;
  String version;
  String devicedata;
  FormData? form;
  bool doLogin;

  Map<String, dynamic>? body;

  Query(
      {required this.destination,
      required this.type,
      required this.doLogin,
      required this.token,
      required this.version,
      this.body,
      required this.startup,
      required this.devicedata,
      required this.form});

  String createurl() {
    return '${dotenv.get('baseurl')}/${dotenv.get('apipath')}/$destination';
  }

  Future<QueryResult?> run() async {
    Dio request = Dio();
    request.options.connectTimeout = const Duration(seconds: 5);
    request.options.receiveTimeout = const Duration(seconds: 5);
    request.options.receiveDataWhenStatusError = true;
    request.options.headers['version'] = version;

    if (type != RequestType.file) {
      request.options.headers['content-type'] = "application/json";
    }

    if (token.isNotEmpty && doLogin) {
      request.options.headers['authorization'] = token;
      request.options.headers['secret'] = dotenv.get('apikey');
    }

    if (devicedata.isNotEmpty) {
      request.options.headers['device'] = devicedata;
    }

    if (startup.isNotEmpty) {
      request.options.headers['startup'] = startup;
    }

    if (dotenv.env['env'].toString() == "production") {
      final String hashed = BCrypt.hashpw(
          dotenv.env['key'].toString(), BCrypt.gensalt(logRounds: 10));
      request.options.headers['secret'] = hashed;
    }

    QueryResult? response;

    Response execute;

    try {
      switch (type) {
        case RequestType.get:
          execute = await request.get(createurl(),
              options: Options(
                  followRedirects: false,
                  maxRedirects: 0,
                  validateStatus: (status) {
                    return status! < 500;
                  }));
          break;

        case RequestType.post:
          execute = await request.post(createurl(),
              data: body,
              options: Options(
                  followRedirects: false,
                  maxRedirects: 0,
                  validateStatus: (status) {
                    return status! < 500;
                  }));

          break;

        case RequestType.delete:
          execute = await request.delete(createurl(), data: body);
          break;

        default:
          return null;
      }

      response = QueryResult.fromJson(execute.statusCode, execute.data);
    } on DioException catch (error) {
      /* Eerrors from dio as  obtained from failed connections */

      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        response = QueryResult(
            status: Httpr.internetFailed, errors: [Protocol.noInternet]);
      } else {
        response = QueryResult.fromJson(
            error.response?.statusCode, error.response?.data);
      }
    }

    return response;
  }
}
