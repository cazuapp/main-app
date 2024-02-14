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

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginProgress extends LoginEvent {
  const LoginProgress(
      {required this.email, required this.password, required this.remember});

  final Email email;
  final Password password;
  final bool remember;

  @override
  List<Object> get props => [email, password, remember];
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginRememberChanged extends LoginEvent {
  final bool remember;

  const LoginRememberChanged(this.remember);

  @override
  List<Object> get props => [remember];
}

class StatsFetch extends LoginEvent {
  const StatsFetch();

  @override
  List<Object> get props => [];
}

class LoginEventOK extends LoginEvent {
  const LoginEventOK();

  @override
  List<Object> get props => [];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class CloseRequest extends LoginEvent {
  const CloseRequest();

  @override
  List<Object> get props => [];
}
