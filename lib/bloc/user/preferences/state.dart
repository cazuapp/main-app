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

class PreferenceState extends Equatable {
  final int result;

  const PreferenceState({
    this.result = Protocol.empty,
  });

  const PreferenceState.initial()
      : this(
          result: Protocol.empty,
        );

  PreferenceState copyWith({
    int? result,
  }) {
    return PreferenceState(
      result: result ?? this.result,
    );
  }

  @override
  List<Object> get props => [result];
}
