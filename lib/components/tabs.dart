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

class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final Widget icon;

  PersistentTabItem({
    required this.tab,
    this.navigatorkey,
    required this.title,
    required this.icon,
  });
}

class PersistentBottomBarScaffold extends StatefulWidget {
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({super.key, required this.items});

  @override
  // ignore: library_private_types_in_public_api
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  late PageController _pageController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        children: widget.items
            .map(
              (page) => PageStorage(
                bucket: PageStorageBucket(),
                child: page.tab, // Use default PageStorageBucket
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: SizedBox(
        height: 57,
        child: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          iconSize: 15,
          selectedItemColor: AppTheme.black,
          selectedLabelStyle: GoogleFonts.ubuntu(
            fontSize: 17.0,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.ubuntu(
            fontSize: 17.0,
            color: AppTheme.darkgray,
            fontWeight: FontWeight.w600,
          ),
          unselectedItemColor: AppTheme.darkgray,
          currentIndex: _selectedTab,
          onTap: (index) async {
            _pageController.jumpToPage(index);
          },
          items: widget.items
              .map((item) =>
                  BottomNavigationBarItem(icon: item.icon, label: item.title))
              .toList(),
        ),
      ),
    );
  }
}
