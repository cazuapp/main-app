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

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class UsersInfoBlocKeyChanged extends UserInfoEvent {
  const UsersInfoBlocKeyChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class UsersInfoEventOK extends UserInfoEvent {
  const UsersInfoEventOK();

  @override
  List<Object> get props => [];
}

class UsersInfoSubmitted extends UserInfoEvent {
  const UsersInfoSubmitted();
}

class UsersInfoPreloadChanged extends UserInfoEvent {
  const UsersInfoPreloadChanged(
      {required this.key, required this.value, required this.iconsrc});

  final LocalKeyEvent key;
  final String value;
  final IconData iconsrc;

  @override
  List<Object> get props => [key, value, iconsrc];
}

class UserProgress extends UserInfoEvent {
  const UserProgress({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class LoadBase extends UserInfoEvent {
  const LoadBase();

  @override
  List<Object> get props => [];
}

class UsersFetchHealth extends UserInfoEvent {
  const UsersFetchHealth();

  @override
  List<Object> get props => [];
}
