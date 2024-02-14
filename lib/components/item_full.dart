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

class ItemFull extends StatelessWidget {
  final String input;
  final IconData iconsrc;
  final VoidCallback? onTap;
  final bool bold;

  const ItemFull(
      {super.key,
      required this.input,
      required this.iconsrc,
      this.onTap,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap!(),
        child: Container(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                visualDensity:
                    const VisualDensity(horizontal: -1, vertical: -1),
                trailing: const Icon(Icons.navigate_next_sharp,
                    color: AppTheme.rightarrow),
                leading: Icon(iconsrc, color: AppTheme.black),
                title: Text(
                  input,
                  style: bold
                      ? GoogleFonts.ubuntu(
                          fontSize: 16.0,
                          color: AppTheme.darkgray,
                          fontWeight: FontWeight.w700)
                      : GoogleFonts.ubuntu(
                          fontSize: 16.0,
                          color: AppTheme.black,
                          fontWeight: FontWeight.w400),
                ),
              )),
            ])));
  }
}
