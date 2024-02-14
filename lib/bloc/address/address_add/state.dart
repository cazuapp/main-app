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

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../models/address.dart';
import '../../../validators/name.dart';
import '../../../validators/optional.dart';
import '../../../validators/zip.dart';

class AddressAddState extends Equatable {
  const AddressAddState(
      {this.model = const Address.initial(),
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errmsg = "",
      this.result = Protocol.empty});

  const AddressAddState.initial()
      : this(
            status: FormzSubmissionStatus.initial,
            result: Protocol.empty,
            isValid: false,
            model: const Address(
                address: Name.pure(),
                createdat: "",
                name: Name.pure(),
                city: Name.pure(),
                zip: Zip.pure(),
                commentary: Optional.pure(),
                options: Optional.pure(),
                id: 0));

  final int result;
  final Address model;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String errmsg;

  AddressAddState copyWith({
    int? result,
    FormzSubmissionStatus? status,
    Address? model,
    bool? isValid,
    String? errmsg,
  }) {
    return AddressAddState(
        errmsg: errmsg ?? this.errmsg,
        model: model ?? this.model,
        result: result ?? this.result,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [errmsg, model, result, status, isValid];
}
