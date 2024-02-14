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

abstract class ForgotAheadEvent extends Equatable {
  const ForgotAheadEvent();

  @override
  List<Object> get props => [];
}

class ForgotEmailChanged extends ForgotAheadEvent {
  const ForgotEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ForgotCodeChanged extends ForgotAheadEvent {
  const ForgotCodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class ForgotPasswordChanged extends ForgotAheadEvent {
  const ForgotPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class ForgotPassword2Changed extends ForgotAheadEvent {
  const ForgotPassword2Changed(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class ForgotEventOK extends ForgotAheadEvent {
  const ForgotEventOK();

  @override
  List<Object> get props => [];
}

class ForgotSubmitted extends ForgotAheadEvent {
  const ForgotSubmitted();
}
