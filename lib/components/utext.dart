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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget utext({
  required String title,
  TextAlign textAlign = TextAlign.left,
  double fontSize = 16,
  Alignment align = Alignment.centerLeft,
  Color color = AppTheme.main,
  FontWeight fontWeight = FontWeight.w100,
  bool resize = false,
  bool shrink = false,
  TextOverflow overflow = TextOverflow.visible,
}) {
  if (shrink && title.length > 20) {
    title = '${title.substring(0, 20)}...';
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Container(
      alignment: align,
      child: Text(
        overflow: overflow,
        textAlign: textAlign,
        title,
        style: GoogleFonts.ubuntu(
          fontSize: !resize ? fontSize : ScreenUtil().scaleWidth * 13,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}
