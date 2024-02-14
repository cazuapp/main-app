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

import 'dart:async';

import 'package:cazuapp/src/cazuapp.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  banned,
  maint,
  nointernet,
  error
}

class AuthenticationRepository {
  final controller = StreamController<AuthenticationStatus>();

  AppInstance instance;

  AuthenticationRepository({required this.instance});

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;

    yield* controller.stream;
  }

  void logout() => controller.add(AuthenticationStatus.unauthenticated);

  void dispose() => controller.close();
}
