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

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ErrorPage());
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
      String errmsg = context
          .select((AuthenticationBloc bloc) => bloc.instance.query.lasterr);

      return Scaffold(
          appBar: null,
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(children: [
                        const SizedBox(height: 136),
                        const Icon(FontAwesomeIcons.triangleExclamation,
                            size: 49, color: AppTheme.softred),
                        const SizedBox(height: 16),
                        Expanded(
                            flex: 0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 35),
                                  utext(
                                      title: "An error has occured",
                                      fontSize: 22,
                                      color: AppTheme.main,
                                      align: Alignment.center,
                                      fontWeight: FontWeight.w800),
                                  const SizedBox(height: 15),
                                  errmsg != ""
                                      ? utext(
                                          title: errmsg,
                                          fontSize: 17,
                                          color: AppTheme.main,
                                          align: Alignment.center,
                                          fontWeight: FontWeight.w400)
                                      : const SizedBox.shrink(),
                                ]))
                      ])))));
    });
  }
}
