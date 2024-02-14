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

abstract class AddressFetchEvent extends Equatable {
  const AddressFetchEvent();
}

class AddressAddressRequest extends AddressFetchEvent {
  const AddressAddressRequest(this.id, {this.historic = false});

  final int id;
  final bool historic;

  @override
  List<Object> get props => [id];
}

class AddressDelete extends AddressFetchEvent {
  const AddressDelete({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}

class AddressManagerOK extends AddressFetchEvent {
  const AddressManagerOK();

  @override
  List<Object> get props => [];
}
