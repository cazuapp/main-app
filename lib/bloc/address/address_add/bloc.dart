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

import 'package:cazuapp/bloc/address/address_add/state.dart';
import 'package:cazuapp/models/address.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/protocol.dart';
import '../../../validators/name.dart';

import '../../../src/cazuapp.dart';
import '../../../validators/optional.dart';
import '../../../validators/zip.dart';

part 'event.dart';

class AddressAddBloc extends Bloc<AddressAddEvent, AddressAddState> {
  final AppInstance instance;

  AddressAddBloc({required this.instance})
      : super(const AddressAddState.initial()) {
    on<AddressAddProgress>(_onAddressAddProgress);

    on<AddressAddressChanged>(_onAddressChanged);
    on<AddressAddEventOK>(_onAddressAddOK);
    on<AddressZipChanged>(_onAddressZipChanged);
    on<AddressCityChanged>(_onAddressCityChanged);
    on<AddressNameChanged>(_onAddressNameChanged);
    on<AddressOptionsChanged>(_onAddressOptionsChanged);
    on<AddressCommentaryChanged>(_onAddressCommentaryChanged);

    on<AddressAddSubmitted>(_onSubmitted);
  }

  void _onAddressAddOK(AddressAddEventOK event, Emitter<AddressAddState> emit) {
    emit(const AddressAddState());
  }

  Future<void> _onAddressAddProgress(
      AddressAddProgress event, Emitter<AddressAddState> emit) async {
    final name = event.address.name;
    final address = event.address.address;
    final zip = event.address.zip;
    final commentary = event.address.commentary;
    final options = event.address.options;
    final city = event.address.city;

    emit(state.copyWith(
        model: state.model.copyWith(
            name: name,
            address: address,
            commentary: commentary,
            options: options,
            zip: zip,
            city: city),
        isValid: false,
        status: FormzSubmissionStatus.initial));
  }

  void _onAddressCommentaryChanged(
      AddressCommentaryChanged event, Emitter<AddressAddState> emit) {
    final commentary = Optional.dirty(event.commentary);

    emit(state.copyWith(
        model: state.model.copyWith(commentary: commentary),
        isValid: Formz.validate([
          state.model.options,
          commentary,
          state.model.name,
          state.model.address,
          state.model.zip,
          state.model.city
        ])));
  }

  void _onAddressOptionsChanged(
      AddressOptionsChanged event, Emitter<AddressAddState> emit) {
    final options = Optional.dirty(event.options);

    emit(state.copyWith(
        model: state.model.copyWith(options: options),
        isValid: Formz.validate([
          options,
          state.model.commentary,
          state.model.name,
          state.model.address,
          state.model.zip,
          state.model.city
        ])));
  }

  void _onAddressNameChanged(
      AddressNameChanged event, Emitter<AddressAddState> emit) {
    final name = Name.dirty(event.name);

    emit(state.copyWith(
        model: state.model.copyWith(name: name),
        isValid: Formz.validate([
          state.model.options,
          state.model.commentary,
          name,
          state.model.address,
          state.model.zip,
          state.model.city
        ])));
  }

  void _onAddressChanged(
      AddressAddressChanged event, Emitter<AddressAddState> emit) {
    final address = Name.dirty(event.address);
    emit(state.copyWith(
        model: state.model.copyWith(address: address),
        isValid: Formz.validate([
          state.model.options,
          state.model.commentary,
          state.model.name,
          address,
          state.model.zip,
          state.model.city
        ])));
  }

  void _onAddressZipChanged(
      AddressZipChanged event, Emitter<AddressAddState> emit) {
    final zip = Zip.dirty(event.zip);
    emit(state.copyWith(
        model: state.model.copyWith(zip: zip),
        isValid: Formz.validate([
          state.model.options,
          state.model.commentary,
          state.model.name,
          state.model.address,
          zip,
          state.model.city
        ])));
  }

  void _onAddressCityChanged(
      AddressCityChanged event, Emitter<AddressAddState> emit) {
    final city = Name.dirty(event.city);
    emit(state.copyWith(
        model: state.model.copyWith(city: city),
        isValid: Formz.validate([
          state.model.options,
          state.model.commentary,
          state.model.name,
          state.model.address,
          state.model.zip,
          city
        ])));
  }

  Future<void> _onSubmitted(
      AddressAddSubmitted event, Emitter<AddressAddState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      String? errmsg = "Error while processing request";

      try {
        int? result = await instance.address.add(
            address: state.model.address.value,
            name: state.model.name.value,
            options: state.model.options.value,
            commentary: state.model.commentary.value,
            city: state.model.city.value,
            zip: state.model.zip.value);

        if (result == Protocol.ok) {
          emit(state.copyWith(
              result: result, status: FormzSubmissionStatus.success));
        } else {
          emit(state.copyWith(
              result: result,
              errmsg: errmsg,
              status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(
            result: Protocol.unknownError,
            status: FormzSubmissionStatus.failure));
      }
    }
  }
}
