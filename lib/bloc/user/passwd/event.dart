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

abstract class PasswdEvent extends Equatable {
  const PasswdEvent();

  @override
  List<Object> get props => [];
}

class CurrentChanged extends PasswdEvent {
  const CurrentChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswdEventOK extends PasswdEvent {
  const PasswdEventOK();

  @override
  List<Object> get props => [];
}

class NewPass2Changed extends PasswdEvent {
  const NewPass2Changed(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class NewPassChanged extends PasswdEvent {
  const NewPassChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswdSubmitted extends PasswdEvent {
  const PasswdSubmitted();
}

class PasswdProgress extends PasswdEvent {
  const PasswdProgress(
      {required this.current, required this.newpass, required this.newpass2});

  final Password current;
  final Password newpass;
  final Password newpass2;

  @override
  List<Object> get props => [current, newpass, newpass2];
}
