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

import 'package:cazuapp/bloc/user/auth/repository.dart';
import 'package:cazuapp/models/user.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AppInstance instance;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc({required this.instance})
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);

    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = instance
        .authenticationRepository!.status
        .listen((status) => add(AuthenticationStatusChanged(status)));
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    instance.authenticationRepository?.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());

      case AuthenticationStatus.banned:
        return emit(const AuthenticationState.banned());

      case AuthenticationStatus.error:
        return emit(const AuthenticationState.error());

      case AuthenticationStatus.nointernet:
        return emit(const AuthenticationState.nointernet());

      case AuthenticationStatus.maint:
        return emit(const AuthenticationState.maint());

      case AuthenticationStatus.authenticated:
        final user = instance.getuser;
        return emit(user != User.initial()
            ? const AuthenticationState.authenticated()
            : const AuthenticationState.unauthenticated());

      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) {
    instance.auth.logout();
  }
}
