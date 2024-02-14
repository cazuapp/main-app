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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalExtended extends StatelessWidget {
  final String title;
  final String right;

  final Color? bgcolor;
  final Color? txtcolor;
  final bool bold;
  final double size;

  const TotalExtended(
      {super.key,
      this.bgcolor,
      this.txtcolor,
      required this.title,
      required this.right,
      this.bold = false,
      this.size = 15.0});

  @override
  Widget build(BuildContext context) {
    final fixed = ScreenUtil().scaleHeight;

    return Container(
        color: bgcolor ?? Colors.transparent,
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Stack(children: <Widget>[
          GestureDetector(
            child: ListTile(
              dense: true,
              minLeadingWidth: 10,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: Text(
                title,
                style: GoogleFonts.ubuntu(
                  fontSize: fixed * 15,
                  color: txtcolor ?? AppTheme.black,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              trailing: Text(
                right,
                style: GoogleFonts.ubuntu(
                  fontSize: fixed * 15,
                  color: txtcolor ?? AppTheme.black,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          )
        ]));
  }
}
