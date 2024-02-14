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

import 'package:cazuapp/components/footer.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Loader());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoaderPage(),
    );
  }
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.02, vertical: size.height * 0.05),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildFooterLogo(),
          ],
        ),
      ),
      backgroundColor: AppTheme.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: Center(
          child: LoadingAnimationWidget.newtonCradle(
            color: AppTheme.iconcolors,
            size: 150,
          ),
        )),
      ]),
    );
  }
}
