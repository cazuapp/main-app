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

import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/components/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class FailurePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? floating;
  final IconData fawesome;
  final Color color;

  const FailurePage(
      {required this.title,
      required this.subtitle,
      this.floating,
      this.fawesome = FontAwesomeIcons.thumbsDown,
      this.color = AppTheme.alert,
      super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.white,
          bottomNavigationBar: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                  color: AppTheme.white,
                  border: Border(
                      top: BorderSide(
                    color: AppTheme.white,
                    width: 1.0,
                  ))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 190,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildFooterLogo(),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          appBar: TopBar(title: title),
          floatingActionButton: floating,
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(children: [
                        const SizedBox(height: 140),
                        Icon(fawesome, size: 49, color: color),
                        const SizedBox(height: 16),
                        Expanded(
                            flex: 0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  utext(
                                      title: subtitle,
                                      fontSize: 19,
                                      color: AppTheme.main,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w400),
                                  const SizedBox(height: 15),
                                  utext(
                                      title:
                                          "We appreciate you being a good member of our community",
                                      fontSize: 15,
                                      color: AppTheme.darkgray,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 50),
                                ]))
                      ])))));
    });
  }
}
