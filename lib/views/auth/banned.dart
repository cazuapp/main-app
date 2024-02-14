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

import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/components/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const BannedPage());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BannedForm(),
    );
  }
}

class BannedForm extends StatefulWidget {
  const BannedForm({super.key});

  @override
  State<BannedForm> createState() => _BannedPage();
}

class _BannedPage extends State<BannedForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const SizedBox(height: 96),
                        const Icon(FontAwesomeIcons.personMilitaryPointing,
                            size: 49, color: AppTheme.black),
                        const SizedBox(height: 16),
                        Expanded(
                            flex: 0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  utext(
                                      title:
                                          "Your account is currently banned.",
                                      fontSize: 22,
                                      color: AppTheme.main,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 15),
                                  utext(
                                      title:
                                          "This is an unfortunate situation.",
                                      fontSize: 15,
                                      color:
                                          const Color.fromARGB(159, 18, 18, 18),
                                      align: Alignment.center),
                                  const SizedBox(height: 25),
                                  utext(
                                      title: "What this means",
                                      fontSize: 17,
                                      color: AppTheme.main,
                                      align: Alignment.bottomLeft,
                                      fontWeight: FontWeight.w500),
                                  utext(
                                      title:
                                          "Your account is currently under review and may be permanently deleted."),
                                  const SizedBox(height: 10),
                                  utext(
                                      title:
                                          "We may still take down your account at any moment."),
                                  const SizedBox(height: 25),
                                  const BuildFooterLogo()
                                ]))
                      ]))))));
    });
  }
}
