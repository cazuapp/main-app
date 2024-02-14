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

import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../views/menu.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: 120,
        child: ElevatedButton.icon(
          icon: const Icon(
            FontAwesomeIcons.house,
            color: AppTheme.white,
            size: 19.0,
          ),
          label: utext(
              title: "Home",
              fontSize: 16,
              color: AppTheme.white,
              align: Alignment.center,
              fontWeight: FontWeight.w500),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            elevation: 3.0,
            backgroundColor: AppTheme.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          key: const Key('signupForm_continue_raisedButton'),
          onPressed: () {
            navigate(context, const MenuPage());
          },
        ));
  }
}

class BuildFooterLogo extends StatelessWidget {
  const BuildFooterLogo({super.key, this.menu = true});
  final bool menu;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: menu == true
            ? () {
                if (menu) {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => const MenuPage()));
                }
              }
            : null,
        child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: RotationTransition(
                turns: const AlwaysStoppedAnimation(-2 / 360),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.kalam(
                      fontSize: 22.12,
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
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            decorationColor: AppTheme.black,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationThickness: 1),
                      ),
                      TextSpan(
                          text: 'App',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w700,
                            decorationThickness: 1,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: AppTheme.black,
                          )),
                    ],
                  ),
                ))));
  }
}
