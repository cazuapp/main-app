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
import 'package:google_fonts/google_fonts.dart';

Widget authhead({required String title, required double fontSize}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: GoogleFonts.ubuntu(
              fontSize: fontSize,
              color: AppTheme.black,
              fontWeight: FontWeight.w600,
            ),
          )));
}
