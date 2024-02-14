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

abstract class AddressAddEvent extends Equatable {
  const AddressAddEvent();

  @override
  List<Object> get props => [];
}

class AddressAddProgress extends AddressAddEvent {
  const AddressAddProgress({required this.address});

  final Address address;

  @override
  List<Object> get props => [address];
}

class AddressAddEventOK extends AddressAddEvent {
  const AddressAddEventOK();

  @override
  List<Object> get props => [];
}

class AddressAddressChanged extends AddressAddEvent {
  const AddressAddressChanged(this.address);

  final String address;

  @override
  List<Object> get props => [address];
}

class AddressZipChanged extends AddressAddEvent {
  const AddressZipChanged(this.zip);

  final String zip;

  @override
  List<Object> get props => [zip];
}

class AddressCommentaryChanged extends AddressAddEvent {
  const AddressCommentaryChanged(this.commentary);

  final String commentary;

  @override
  List<Object> get props => [commentary];
}

class AddressOptionsChanged extends AddressAddEvent {
  const AddressOptionsChanged(this.options);

  final String options;

  @override
  List<Object> get props => [options];
}

class AddressNameChanged extends AddressAddEvent {
  const AddressNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class AddressCityChanged extends AddressAddEvent {
  const AddressCityChanged(this.city);

  final String city;

  @override
  List<Object> get props => [city];
}

class AddressAddSubmitted extends AddressAddEvent {
  const AddressAddSubmitted();
}
