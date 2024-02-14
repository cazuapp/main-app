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

abstract class ForgotEvent extends Equatable {
  const ForgotEvent();

  @override
  List<Object> get props => [];
}

class ForgotProgress extends ForgotEvent {
  const ForgotProgress({required this.email});

  final Email email;

  @override
  List<Object> get props => [email];
}

class ForgotEmailChanged extends ForgotEvent {
  const ForgotEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ForgotEventOK extends ForgotEvent {
  const ForgotEventOK();

  @override
  List<Object> get props => [];
}

class ForgotSubmitted extends ForgotEvent {
  const ForgotSubmitted();
}
