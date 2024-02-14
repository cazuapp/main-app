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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusCheck extends StatelessWidget {
  final String input;
  final int icon;
  final VoidCallback? ok;
  final VoidCallback? error;
  final IconData iconsrc;

  const StatusCheck(
      {super.key,
      required this.input,
      required this.icon,
      required this.iconsrc,
      this.ok,
      this.error});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => icon == 1 ? ok!() : error!(),
        child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                visualDensity:
                    const VisualDensity(horizontal: -1, vertical: -1),
                trailing: Icon(
                    icon == 1
                        ? FontAwesomeIcons.solidThumbsUp
                        : FontAwesomeIcons.solidThumbsDown,
                    color:
                        icon == 1 ? AppTheme.focussecondary : AppTheme.alert),
                leading: Icon(iconsrc, color: AppTheme.black),
                title: Text(
                  input,
                  style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      color: const Color.fromARGB(221, 0, 0, 0),
                      fontWeight: FontWeight.w400),
                ),
              )),
            ])));
  }
}
