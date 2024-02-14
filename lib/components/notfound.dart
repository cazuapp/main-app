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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class NotFoundPage extends StatelessWidget {
  final String title;
  final String main;
  final Widget? floating;

  const NotFoundPage(
      {required this.title, required this.main, this.floating, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      final fixed = ScreenUtil().scaleHeight;

      return Scaffold(
          resizeToAvoidBottomInset: false,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          floating ?? const SizedBox.shrink(),
                          floating != null
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),
                          //  const HomeButton(),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          appBar: TopBar(title: title),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.12, vertical: fixed * 10),
                      child: Column(children: [
                        SizedBox(height: fixed * 60),
                        Icon(FontAwesomeIcons.thumbsUp,
                            size: fixed * 35, color: AppTheme.focussecondary),
                        SizedBox(height: fixed * 50),
                        Expanded(
                            flex: 0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  utext(
                                      title: main,
                                      fontSize: 19,
                                      color: AppTheme.main,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w400),
                                  SizedBox(height: fixed * 20),
                                  utext(
                                      title:
                                          "We appreciate you being a good member of our community",
                                      fontSize: 15,
                                      color: AppTheme.darkgray,
                                      align: Alignment.center,
                                      textAlign: TextAlign.center),
                                  SizedBox(height: fixed * 5),
                                ]))
                      ])))));
    });
  }
}
