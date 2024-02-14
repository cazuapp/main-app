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

import 'package:cazuapp/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemExtended extends StatelessWidget {
  final String? title;
  final String input;
  final IconData? iconsrc;
  final dynamic fawesome;
  final VoidCallback? onTap;
  final bool external;
  final bool red;

  const ItemExtended(
      {super.key,
      this.fawesome,
      this.title,
      this.external = false,
      required this.input,
      this.iconsrc,
      this.onTap,
      this.red = false});

  @override
  Widget build(BuildContext context) {
    dynamic display;

    if (external) {
      display = const Icon(Icons.keyboard_double_arrow_right_rounded,
          color: AppTheme.black);
    } else {
      display =
          const Icon(Icons.navigate_next_sharp, color: AppTheme.rightarrow);
    }

    return InkWell(
        onTap: () async => onTap != null ? onTap!() : null,
        child: Container(
            color: red ? AppTheme.softred : AppTheme.white,
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                visualDensity:
                    const VisualDensity(horizontal: -1, vertical: -1),
                subtitle: Text(title ?? "",
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      color: red ? AppTheme.white : Colors.black87,
                      fontWeight: FontWeight.w400,
                    )),
                trailing: onTap != null ? display : const SizedBox.shrink(),
                leading: fawesome != null
                    ? Icon(fawesome,
                        color: red ? AppTheme.white : AppTheme.black, size: 22)
                    : Icon(iconsrc, color: AppTheme.black, size: 22),
                title: Text(
                  input,
                  style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      color: red ? AppTheme.white : AppTheme.black,
                      fontWeight: FontWeight.w500),
                ),
              )),
            ])));
  }
}
