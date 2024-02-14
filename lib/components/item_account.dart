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

class ItemAccount extends StatelessWidget {
  final String title;
  final IconData? iconsrc;
  final VoidCallback? onTap;
  final dynamic fawesome;
  final Color? bgcolor;
  final Color? txtcolor;

  const ItemAccount(
      {super.key,
      this.bgcolor,
      this.txtcolor,
      this.fawesome,
      required this.title,
      this.iconsrc,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap!(),
        child: Container(
            color: bgcolor ?? Colors.transparent,
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Stack(children: <Widget>[
              GestureDetector(
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -1, vertical: -1),
                  trailing: const Icon(Icons.navigate_next_sharp,
                      color: AppTheme.rightarrow),
                  leading: fawesome != null
                      ? Icon(fawesome, color: AppTheme.black)
                      : Icon(iconsrc, color: AppTheme.black),
                  title: Text(
                    title,
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      color: txtcolor ?? AppTheme.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ])));
  }
}
