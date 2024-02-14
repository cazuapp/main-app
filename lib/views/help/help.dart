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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HelpPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: HelpForm(),
      ),
    );
  }
}

class HelpForm extends StatelessWidget {
  const HelpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.white,
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
          appBar: const TopBar(title: "Help"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            const Icon(FontAwesomeIcons.question,
                                size: 49, color: AppTheme.lockeye),
                            const SizedBox(height: 16),
                            Expanded(
                                flex: 0,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      utext(
                                          title: "Help",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          color: AppTheme.main,
                                          align: Alignment.center,
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 25),
                                      utext(
                                          title: "What is CazuApp?",
                                          fontSize: 17,
                                          color: AppTheme.main,
                                          align: Alignment.bottomLeft,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 10),
                                      utext(
                                        title:
                                            "CazuApp is an open-source app designed to assist small businesses in enhancing their delivery services through iOS and Android devices, thereby improving their customers' experience.",
                                      ),
                                      const SizedBox(height: 12),
                                      utext(
                                          title:
                                              "More information can be found vising our official documentation at https://docs.cazuapp.dev"),
                                    ]))
                          ])))));
    });
  }
}
