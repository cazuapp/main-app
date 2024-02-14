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

enum AddressStatus { initial, loading, success, failure }

class AddressManagerState extends Equatable {
  const AddressManagerState(
      {required this.address,
      required this.errmsg,
      required this.status,
      this.current = AddressStatus.initial});

  const AddressManagerState.initial()
      : this(
            status: Protocol.empty,
            errmsg: "",
            address: const Address(
                address: Name.pure(),
                createdat: "",
                name: Name.pure(),
                city: Name.pure(),
                zip: Zip.pure(),
                commentary: Optional.pure(),
                options: Optional.pure(),
                id: 0));

  final Address address;
  final int status;
  final AddressStatus current;
  final String errmsg;

  AddressManagerState copyWith(
      {Address? address, int? status, String? errmsg, required current}) {
    return AddressManagerState(
        errmsg: errmsg ?? this.errmsg,
        address: address ?? this.address,
        status: status ?? this.status,
        current: current ?? this.current);
  }

  @override
  List<Object> get props => [address, errmsg, current];
}
