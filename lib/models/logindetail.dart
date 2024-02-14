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

class LoginDetail extends Equatable {
  final String ip;
  final String browser;
  final String os;
  final String updatedat;

  const LoginDetail(
      {required this.ip,
      required this.browser,
      required this.os,
      required this.updatedat});
  const LoginDetail.initial()
      : this(ip: '', browser: '', os: '', updatedat: '');

  factory LoginDetail.fromJson(Map<dynamic, dynamic> json) {
    return LoginDetail(
        ip: json['ip'] ?? "",
        browser: json['browser'] ?? "",
        updatedat: json['updatedat'] ?? "",
        os: json['os'] ?? "");
  }

  Map<dynamic, dynamic> toJson(LoginDetail instance) => <dynamic, dynamic>{
        'ip': instance.ip,
        'browser': instance.browser,
        'updatedat': instance.updatedat,
        'os': instance.os
      };

  @override
  List<Object> get props => [ip, browser, updatedat, os];

  @override
  String toString() =>
      'LoginDetail { ip: $ip, browser: $browser, updatedat: $updatedat,  os: $os }';
}
