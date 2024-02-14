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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/collections/collection_list.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => const CollectionPage()));
        },
        child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: 160,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        color: AppTheme.mainbg,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.ubuntu(
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'See all',
                                    style: GoogleFonts.inter(
                                      color: AppTheme.secondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 0, right: 0),
                                      child: const Icon(
                                          size: 15,
                                          FontAwesomeIcons.arrowRightLong,
                                          color: AppTheme.secondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 0.0,
                            ),
                          ],
                        ))
                  ]),
            )));
  }
}
