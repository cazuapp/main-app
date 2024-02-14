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

part of 'bloc.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final String errmsg;

  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown, this.errmsg = ""});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.banned()
      : this._(status: AuthenticationStatus.banned);

  const AuthenticationState.maint()
      : this._(status: AuthenticationStatus.maint);

  const AuthenticationState.error()
      : this._(status: AuthenticationStatus.error);

  const AuthenticationState.nointernet()
      : this._(status: AuthenticationStatus.nointernet);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticated()
      : this._(status: AuthenticationStatus.authenticated);

  @override
  List<Object> get props => [status, errmsg];
}
