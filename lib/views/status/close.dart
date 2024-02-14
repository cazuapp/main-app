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

import 'package:cazuapp/core/protocol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../bloc/user/login/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class ClosePage extends StatelessWidget {
  const ClosePage({super.key});

  Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ClosePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance),
      child: const CloseForm(),
    );
  }
}

class CloseForm extends StatelessWidget {
  const CloseForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixed = ScreenUtil().scaleHeight * 1.33;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.result != Protocol.empty && state.result != Protocol.ok) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.mainbg,
            appBar: const TopBar(title: "Close account"),
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.12,
                            vertical: fixed * 35.05),
                        child: Column(children: [
                          SizedBox(height: fixed * 2.3),
                          Icon(FontAwesomeIcons.triangleExclamation,
                              size: fixed * 43, color: AppTheme.remove),
                          Expanded(
                              flex: 0,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: fixed * 20),
                                    utext(
                                        title: "Warning",
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.main,
                                        fontSize: 22,
                                        align: Alignment.center),
                                    SizedBox(height: fixed * 10),
                                    utext(
                                        textAlign: TextAlign.center,
                                        title:
                                            "If you close your account, you may lose your data",
                                        fontSize: 18,
                                        color: const Color.fromARGB(
                                            159, 18, 18, 18),
                                        align: Alignment.center),
                                    SizedBox(height: fixed * 22),
                                    utext(
                                      align: Alignment.center,
                                      textAlign: TextAlign.center,
                                      title:
                                          "Do you really want to close your account?",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: AppTheme.black,
                                    ),
                                    SizedBox(height: fixed * 15),
                                    const ConfirmButton()
                                  ]))
                        ]))))));
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: ScreenUtil().scaleHeight * 50,
            width: ScreenUtil().scaleWidth * 500,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(ScreenUtil().scaleHeight * 50),
                  elevation: 0,
                  backgroundColor: AppTheme.remove,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  context.read<LoginBloc>().add(const CloseRequest());
                },
                child: Center(
                  child: utext(
                    title: "Close Account",
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mainbg,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
