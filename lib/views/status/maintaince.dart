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
import '../../../components/ok.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

class MaintaincePage extends StatelessWidget {
  const MaintaincePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MaintaincePage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: MaintainceForm(),
      ),
    );
  }
}

class MaintainceForm extends StatelessWidget {
  const MaintainceForm({super.key});

  Widget refreshButton() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return SizedBox(
          height: 40,
          width: 140,
          child: ElevatedButton.icon(
              icon: const Icon(
                FontAwesomeIcons.recycle,
                color: AppTheme.mainbg,
                size: 19.0,
              ),
              label: utext(
                  title: "Refresh",
                  textAlign: TextAlign.center,
                  align: Alignment.center,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.white),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                elevation: 4.0,
                backgroundColor: AppTheme.subprimarycolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
              key: const Key('signupForm_continue_raisedButton'),
              onPressed: () {
                var displaymsg = "Refreshing ..";

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(buildOk(displaymsg));

                BlocProvider.of<AuthenticationBloc>(context)
                    .instance
                    .pingServer();
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          bottomNavigationBar: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                  color: AppTheme.settings,
                  border: Border(
                      top: BorderSide(
                    color: AppTheme.darkset,
                    width: 1.0,
                  ))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          refreshButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          appBar: null,
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.gear,
                                size: 49, color: AppTheme.black),
                            const SizedBox(height: 6),
                            Expanded(
                                flex: 0,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 35),
                                      utext(
                                          title:
                                              "Our server is under maintaince",
                                          fontSize: 22,
                                          color: AppTheme.main,
                                          align: Alignment.center,
                                          fontWeight: FontWeight.w400),
                                      const SizedBox(height: 15),
                                      utext(
                                          align: Alignment.center,
                                          title:
                                              "We're sorry this situation is happening",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: const Color.fromARGB(
                                              159, 18, 18, 18)),
                                      const SizedBox(height: 25),
                                    ]))
                          ])))));
    });
  }
}
