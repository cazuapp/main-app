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
import '../../../bloc/user/login/bloc.dart';
import '../../../components/etc.dart';
import '../../../components/iconextended.dart';
import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AboutPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: const AboutForm(),
      ),
    );
  }
}

class AboutForm extends StatelessWidget {
  const AboutForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "About"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.04),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const SizedBox(height: 10),
                        Container(
                            alignment: Alignment.topLeft,
                            child: utext(
                                fontSize: 14,
                                title: "About",
                                color: AppTheme.title,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Expanded(
                            flex: 0,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ItemExtended(
                                        input: "Account Created",
                                        title: context.select(
                                            (AuthenticationBloc bloc) => bloc
                                                .instance.getuser.created
                                                .toString()),
                                        iconsrc: FontAwesomeIcons.database,
                                      ),
                                      ItemExtended(
                                        input: "System",
                                        title: context.select(
                                            (AuthenticationBloc bloc) =>
                                                bloc.instance.os),
                                        iconsrc: FontAwesomeIcons.server,
                                      ),
                                      IconExtended(
                                        input: "Email verified",
                                        title: Etc.fromint(context.select(
                                            (AuthenticationBloc bloc) => bloc
                                                .instance.getuser.verified)),
                                        status: context.select(
                                            (AuthenticationBloc bloc) =>
                                                bloc.instance.getuser.verified),
                                      ),
                                      ItemExtended(
                                        input: "API Version",
                                        title: context.select(
                                            (AuthenticationBloc bloc) => bloc
                                                .instance.getserver!.version
                                                .toString()),
                                        iconsrc: Icons.view_module,
                                      ),
                                    ]))),
                      ]))))));
    });
  }
}
