/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

enum Param { all, mine, nopayment, cancelled, nodriver, pending, other }

enum BanCodeStatus { noban, badbehavior, badaction }

extension StringExtension on String {
  String capitalize() {
    if (trim().isEmpty) return "";

    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension ParseKeyToString on Param {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension ParseBanToString on BanCodeStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}

class Etc {
  static String staticlistToTupleString(List<dynamic> list) {
    return '(${list.join(', ')})';
  }

  static BanCodeStatus? convertBan(input) {
    if (input == null || input.isEmpty || input == "noban") {
      return BanCodeStatus.noban;
    } else if (input == "badbehavior") {
      return BanCodeStatus.badbehavior;
    } else if (input == "badaction") {
      return BanCodeStatus.badaction;
    }

    return null;
  }

  static String fromBan(input) {
    if (input == BanCodeStatus.noban.toShortString()) {
      return "No ban";
    } else if (input == BanCodeStatus.badbehavior.toShortString()) {
      return "Bad Behavior";
    } else if (input == BanCodeStatus.badaction.toShortString()) {
      return "Bad Action";
    }

    return "";
  }

  static bool intToBoolean(dynamic input) {
    if (input == 1 || input == true || input == "yes") {
      return true;
    }

    return false;
  }

  static String getToday() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String betterBool(bool input) {
    if (input == true) {
      return "Yes";
    }

    return "No";
  }

  static String prettySmalldate(input) {
    DateTime result = DateTime.parse(input).toUtc();
    String format = Jiffy.parseFromMap({
      Unit.hour: result.hour,
      Unit.minute: result.minute,
      Unit.year: result.year,
      Unit.month: result.month,
      Unit.day: result.day
    }).format(pattern: 'MMMM do, yyyy  ');

    return format;
  }

  static String prettydate(input) {
    DateTime result = DateTime.parse(input).toUtc();
    String format = Jiffy.parseFromMap({
      Unit.hour: result.hour,
      Unit.minute: result.minute,
      Unit.year: result.year,
      Unit.month: result.month,
      Unit.day: result.day
    }).format(pattern: 'HH:mm, MMMM do, yyyy  ');

    return format;
  }

  static String makepublic({required destination}) {
    if (destination == null) {
      return '${dotenv.get('baseurl')}/assets/images/etc/null.png';
    }

    return '${dotenv.get('baseurl')}/$destination';
  }

  /* Launches a phone */
  static Future<bool> launchPhone({String? dest}) async {
    final String target = "tel://$dest";
    final Uri url = Uri.parse(target);
    if (!await launchUrl(url)) {
      return false;
    }

    return true;
  }

  static Future<bool> launchURL({String? base, String? dest}) async {
    final String target = "$base/$dest";
    final Uri url = Uri.parse(target);
    if (!await launchUrl(url)) {
      return false;
    }

    return true;
  }

  static String toBoolean(bool input) {
    if (input == true) {
      return "true";
    }

    return "false";
  }

  static bool asBoolean(String? input) {
    if (input == "true") {
      return true;
    }

    return false;
  }

  static int fromstring(String? input) {
    if (input == "true" || input == "1") {
      return 1;
    }

    return 0;
  }

  static String fromint(int number) {
    if (number == 1) {
      return "Yes";
    }

    return "No";
  }

  static bool isNumeric(String str) {
    try {
      double.parse(str);
    } on FormatException {
      return false;
    } finally {
      // ignore: control_flow_in_finally
      return true;
    }
  }

  static listToTupleString(List list) {}
}
