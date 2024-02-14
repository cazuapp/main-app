// ignore_for_file: non_constant_identifier_names

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

import 'package:json_annotation/json_annotation.dart';

part 'first_ping.g.dart';

@JsonSerializable()
class FirstPing {
  /* Latest version */

  final String latest;

  /* Store's url */

  final String url;

  /* Version to switch into (if any) */

  final String use;

  /* Whether app is under maintaince or not */

  bool maint;

  /* Whether the app is open or not */

  bool online;

  /* Whether the app is taking orders */

  bool orders;

  FirstPing.initial()
      : this(
            latest: '',
            url: '',
            online: true,
            use: '',
            maint: false,
            orders: true);

  FirstPing(
      {required this.latest,
      required this.url,
      required this.online,
      required this.use,
      required this.maint,
      required this.orders});

  factory FirstPing.fromJson(Map<String, dynamic> json) =>
      _$FirstPingFromJson(json);

  Map<String, dynamic> toJson() => _$FirstPingToJson(this);
}
