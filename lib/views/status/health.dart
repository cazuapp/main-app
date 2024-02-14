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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HealthPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: HealthForm(),
      ),
    );
  }
}

class HealthForm extends StatelessWidget {
  const HealthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          appBar: const TopBar(title: "Health status"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.thumbsUp,
                                size: 49, color: AppTheme.focussecondary),
                            const SizedBox(height: 25),
                            Expanded(
                                flex: 0,
                                child: Column(children: [
                                  utext(
                                      title:
                                          "Your account is not affected right now",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      color: AppTheme.main,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 15),
                                  utext(
                                      title:
                                          "We appreciate you being a good customer",
                                      fontSize: 15,
                                      color: AppTheme.black,
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
                                          "You are not at any risk of losing access to your account right now."),
                                  const SizedBox(height: 10),
                                  utext(
                                      title:
                                          "We may still take down your account without previous notice if you misuse or present a risk to this delivery app."),
                                  const SizedBox(height: 25),
                                  utext(
                                      title: "What you can do",
                                      fontSize: 17,
                                      color: AppTheme.main,
                                      align: Alignment.bottomLeft,
                                      fontWeight: FontWeight.w500),
                                  utext(
                                      title:
                                          "Nothing! you are doing just fine! we're happy you are here.",
                                      align: Alignment.bottomLeft),
                                ]))
                          ])))));
    });
  }
}
