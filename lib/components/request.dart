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

enum RequestType { post, delete, head, get, file }

enum OrderDeliveryStatus { pending, cancelled, nodriver, active, delivered }

enum LocalKeyEvent {
  empty,
  first,
  last,
  email,
  phone,
  phonecode,
  lang,
  name,
  address,
  city,
  commentary,
  zip,
  options
}

extension ParseKeyToString on LocalKeyEvent {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
