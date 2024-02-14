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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/ok.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NoInternetPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: NoInternetForm(),
    );
  }
}

class NoInternetForm extends StatelessWidget {
  const NoInternetForm({super.key});

  Widget refreshButton() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return SizedBox(
          height: 40,
          width: 140,
          child: ElevatedButton.icon(
              icon: const Icon(
                FontAwesomeIcons.arrowsRotate,
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
                backgroundColor: AppTheme.lockeye,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              key: const Key('signupForm_continue_raisedButton'),
              onPressed: () async {
                var displaymsg = "Refreshing ..";

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(buildOk(displaymsg));

                AuthenticationBloc authbloc =
                    BlocProvider.of<AuthenticationBloc>(context);

                if (await authbloc.instance.pingServer() == true) {
                  await authbloc.instance.init();
                }
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
          backgroundColor: AppTheme.white,
          bottomNavigationBar: Container(
              padding: const EdgeInsets.all(3.0),
              /*decoration: const BoxDecoration(
                  color: AppTheme.settings,
                  border: Border(
                      top: BorderSide(
                    color: AppTheme.darkset,
                    width: 1.0,
                  ))),*/
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BuildFooterLogo(menu: false),
                    Container(
                      width: 190,
                      height: 90,
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
          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // transparent status bar
                statusBarIconBrightness:
                    Brightness.dark, // status bar icons' color
              ),
              child: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.12),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(FontAwesomeIcons.wifi,
                                              size: 49,
                                              color: AppTheme.secondary),
                                          const SizedBox(height: 35),
                                          utext(
                                              title:
                                                  "Unable to connect to server",
                                              fontSize: 20,
                                              color: AppTheme.main,
                                              align: Alignment.center,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center),
                                          const SizedBox(height: 15),
                                          utext(
                                              align: Alignment.center,
                                              title:
                                                  "We're sorry this situation is happening",
                                              textAlign: TextAlign.center,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromARGB(
                                                  159, 18, 18, 18)),
                                          const SizedBox(height: 25),
                                        ]))
                              ]))))));
    });
  }
}
