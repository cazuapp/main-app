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

import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class IconExtended extends StatelessWidget {
  final String? title;
  final String input;

  final int status;
  final VoidCallback? onTap;

  const IconExtended(
      {super.key,
      required this.status,
      this.title,
      required this.input,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap != null ? onTap!() : null,
        child: Container(
            padding: const EdgeInsets.only(top: 2),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                visualDensity:
                    const VisualDensity(horizontal: -1, vertical: -1),
                subtitle: utext(title: title ?? ""),
                trailing: onTap != null
                    ? const Icon(Icons.navigate_next_sharp,
                        color: AppTheme.rightarrow)
                    : const SizedBox.shrink(),
                leading: status == 1
                    ? const Icon(FontAwesomeIcons.solidThumbsUp,
                        color: AppTheme.black)
                    : const Icon(FontAwesomeIcons.solidThumbsDown,
                        color: AppTheme.alert),
                title: Text(
                  input,
                  style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      color: AppTheme.darkgray,
                      fontWeight: FontWeight.w700),
                ),
              )),
            ])));
  }
}
