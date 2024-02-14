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

import 'package:cazuapp/bloc/user/forgot/bloc.dart';
import 'package:cazuapp/components/authhead.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/views/auth/forgot_ahead.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cazuapp/views/auth/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../bloc/user/auth/bloc.dart';
import '../../components/utext.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (_) => ForgotBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance,
        ),
        child: const ForgotForm(),
      ),
    );
  }
}

class ForgotForm extends StatelessWidget {
  const ForgotForm({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenHeight = ScreenUtil().scaleHeight;

    return BlocListener<ForgotBloc, ForgotState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          String? errmsg = state.errmsg;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(buildAlert(errmsg));

          BlocProvider.of<ForgotBloc>(context).add(ForgotProgress(
            email: state.email,
          ));
        } else if (state.status.isSuccess) {
          BlocProvider.of<ForgotBloc>(context).add(const ForgotEventOK());
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: screenHeight * -150,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.12,
                          vertical: size.height * 0.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: screenHeight * 200,
                                        width: double.infinity,
                                      ),
                                      Positioned(
                                        child: Image.asset(
                                          'assets/images/logot.png',
                                          width: 180.0,
                                          height: 100.0,
                                        ),
                                      ),
                                      Positioned(
                                        top: 130 * screenHeight,
                                        child:
                                            buildHeader(), // Placeholder for buildHeader()
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 20,
                                  ),
                                  authhead(
                                    title: "Forgot password",
                                    fontSize: ScreenUtil().setSp(17.0),
                                  ),
                                  const BuildEmail(),
                                  SizedBox(height: screenHeight * 20),
                                  const ForgotButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildEmail extends StatelessWidget {
  const BuildEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotBloc, ForgotState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: ScreenUtil().scaleHeight * 50,
          width: ScreenUtil().scaleWidth * 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              colors: [Colors.grey[200]!, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.mail_rounded, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    key: const Key('loginForm_emailInput_textField'),
                    onChanged: (email) => context
                        .read<ForgotBloc>()
                        .add(ForgotEmailChanged(email)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ForgotButton extends StatelessWidget {
  const ForgotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotBloc, ForgotState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  height: ScreenUtil().scaleHeight * 50,
                  width: ScreenUtil().scaleWidth * 500,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: state.isValid
                              ? AppTheme.lockeye2
                              : Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size.fromHeight(ScreenUtil().scaleHeight * 50),
                        elevation: 0,
                        backgroundColor:
                            state.isValid ? AppTheme.lockeye2 : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      key: const Key('forgotForm_continue_raisedButton'),
                      onPressed: state.isValid
                          ? () {
                              context
                                  .read<ForgotBloc>()
                                  .add(const ForgotSubmitted());

                              navigate(context, const ForgotAheadPage());
                            }
                          : null,
                      child: Center(
                        child: utext(
                          title: "Reset Password",
                          textAlign: TextAlign.center,
                          align: Alignment.center,
                          fontWeight: FontWeight.w500,
                          color: state.isValid
                              ? AppTheme.mainbg
                              : AppTheme.yesArrow,
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
