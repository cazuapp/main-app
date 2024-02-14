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

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupPasswordChanged extends SignupEvent {
  const SignupPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignupFirstChanged extends SignupEvent {
  const SignupFirstChanged(this.first);

  final String first;

  @override
  List<Object> get props => [first];
}

class SignupEventOK extends SignupEvent {
  const SignupEventOK();

  @override
  List<Object> get props => [];
}

class SignupPhoneChanged extends SignupEvent {
  const SignupPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

class SignupLastChanged extends SignupEvent {
  const SignupLastChanged(this.last);

  final String last;

  @override
  List<Object> get props => [last];
}

class SignupEmailChanged extends SignupEvent {
  const SignupEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

class SignupProgress extends SignupEvent {
  const SignupProgress(
      {required this.email,
      required this.password,
      required this.first,
      required this.last,
      required this.phone});

  final String email;
  final String password;
  final String first;
  final String last;
  final String phone;

  @override
  List<Object> get props => [email, password, first, last, phone];
}
