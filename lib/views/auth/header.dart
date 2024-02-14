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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

Widget buildHeader() {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
            turns: const AlwaysStoppedAnimation(-7 / 360),
            child: Text.rich(
              TextSpan(
                style: GoogleFonts.kalam(
                  fontSize: 42.12,
                  color: AppTheme.subprimarycolordeco,
                  letterSpacing: .13,
                  shadows: <Shadow>[
                    const Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                      color: Color.fromARGB(255, 200, 200, 200),
                    ),
                    const Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      color: Color.fromARGB(205, 0, 0, 0),
                    ),
                  ],
                ),
                children: const [
                  TextSpan(
                    text: 'Cazu',
                    style: TextStyle(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        decorationColor: AppTheme.darkgray,
                        decoration: TextDecoration.underline,
                        //decorationStyle: TextDecorationStyle.wavy,
                        decorationThickness: 1),
                  ),
                  TextSpan(
                      text: 'App',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.black,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                        decorationThickness: 1,
                        //decorationStyle: TextDecorationStyle.wavy,
                        decorationColor: AppTheme.darkgray,
                      )),
                  /*TextSpan(
                text: '!',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 36.12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                ),
              ),*/
                ],
              ),
            ))
      ]);
}
