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

import '../../../bloc/user/auth/bloc.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class NoRestrictionsPage extends StatelessWidget {
  const NoRestrictionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NoRestrictionsPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: NoHealthForm(),
      ),
    );
  }
}

class NoHealthForm extends StatelessWidget {
  const NoHealthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    var contact = BlocProvider.of<AuthenticationBloc>(context)
        .instance
        .settings
        .getValue(key: 'contact');

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          appBar: const TopBar(title: "Restrictions"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(children: [
                        const SizedBox(height: 36),
                        const Icon(Icons.warning_outlined,
                            size: 49, color: AppTheme.alert),
                        const SizedBox(height: 16),
                        Expanded(
                            flex: 0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  utext(
                                      title: "Your account has restrictions",
                                      fontSize: 22,
                                      color: AppTheme.main,
                                      align: Alignment.center),
                                  const SizedBox(height: 15),
                                  utext(
                                      title:
                                          "We're sorry this situation is happening",
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
                                          "Your account may not be fully functional."),
                                  const SizedBox(height: 10),
                                  utext(
                                      title:
                                          "We may still take down your account at any moment."),
                                  const SizedBox(height: 25),
                                  utext(
                                      title: "What you can do",
                                      fontSize: 17,
                                      color: AppTheme.main,
                                      align: Alignment.bottomLeft,
                                      fontWeight: FontWeight.w500),
                                  utext(
                                      title: "Email our team directly at",
                                      align: Alignment.bottomLeft),
                                  const SizedBox(height: 15),
                                  utext(
                                      title: "$contact",
                                      fontWeight: FontWeight.w400,
                                      align: Alignment.center),
                                  const SizedBox(height: 25),
                                ]))
                      ])))));
    });
  }
}
