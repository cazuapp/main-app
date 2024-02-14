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

import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/account/store.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const TopBar({required this.title, super.key, this.self = false})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;
  final bool self;

  @override
  // ignore: library_private_types_in_public_api
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {},
        child: AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: <Widget>[
            InkWell(
                onTap: () => widget.self == false
                    ? {navigate(context, const StorePage())}
                    : null,
                child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Align(
                        alignment: Alignment.center,
                        child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(-4 / 360),
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.kalam(
                                  fontSize: 20.12,
                                  color: AppTheme.mainbg,
                                  letterSpacing: .6,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Cazu',
                                    style: TextStyle(
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(
                                    text: 'App',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ))))),
          ],
          leading: IconButton(
              icon: Icon(
                  Navigator.of(context).canPop()
                      ? FontAwesomeIcons.arrowLeftLong
                      : FontAwesomeIcons.house,
                  size: 15,
                  color: AppTheme.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                }
              }),
          backgroundColor: AppTheme.primarycolor,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: utext(
                color: AppTheme.white,
                textAlign: TextAlign.left,
                title: widget.title,
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}
