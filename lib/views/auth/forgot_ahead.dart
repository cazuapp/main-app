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

import 'package:cazuapp/bloc/user/forgot_ahead/bloc.dart';
import 'package:cazuapp/components/navigator.dart';

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
import '../../components/authhead.dart';
import '../../components/utext.dart';
import 'login.dart';

class ForgotAheadPage extends StatelessWidget {
  const ForgotAheadPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotAheadPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (_) => ForgotAheadBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: const ForgotAheadForm(),
      ),
    );
  }
}

class ForgotAheadForm extends StatelessWidget {
  const ForgotAheadForm({super.key});

  Widget registerButton() {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
      builder: (context, state) {
        return SizedBox(
            height: 40,
            width: 130,
            child: InkWell(
                child: utext(
                    title: 'Login',
                    color: AppTheme.iconcolors,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center,
                    align: Alignment.center),
                onTap: () {
                  navigate(context, const LoginPage());
                }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenHeight = ScreenUtil().scaleHeight;

    return BlocListener<ForgotAheadBloc, ForgotAheadState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            String? errmsg = state.errmsg;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(errmsg));
          } else if (state.status.isSuccess) {
            BlocProvider.of<ForgotAheadBloc>(context)
                .add(const ForgotEventOK());
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
                      child: Stack(children: <Widget>[
                        Positioned(
                            top: screenHeight * -70,
                            child: SizedBox(
                                width: size.width,
                                height: size.height,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.12,
                                      vertical: size.height * 0.0,
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height:
                                                          screenHeight * 200,
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
                                                  title: "Forgot Password",
                                                  fontSize:
                                                      ScreenUtil().setSp(17.0),
                                                ),
                                                const BuildEmail(),
                                                SizedBox(
                                                    height: screenHeight * 20),
                                                const BuildCode(),
                                                SizedBox(
                                                    height: screenHeight * 20),
                                                const BuildPassword(),
                                                SizedBox(
                                                    height: screenHeight * 20),
                                                const BuildPassword2(),
                                                SizedBox(
                                                    height: screenHeight * 20),
                                                const ChangeButton(),
                                              ],
                                            ),
                                          ),
                                        ])))),
                      ]))),
            )));
  }
}

class BuildEmail extends StatelessWidget {
  const BuildEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
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
                    key: const Key('forgotForm_emailInput_textField'),
                    autofocus: true,
                    onChanged: (email) => context
                        .read<ForgotAheadBloc>()
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

class BuildCode extends StatelessWidget {
  const BuildCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
      buildWhen: (previous, current) => previous.code != current.code,
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
                const Icon(Icons.code, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    key: const Key('codeForm_emailInput_textField'),
                    onChanged: (code) => context
                        .read<ForgotAheadBloc>()
                        .add(ForgotCodeChanged(code)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Code',
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

class BuildPassword extends StatefulWidget {
  const BuildPassword({super.key});

  @override
  State<BuildPassword> createState() => _BuildPassword();
}

class _BuildPassword extends State<BuildPassword> {
  bool _passVisibility = true;

  void _toggleVisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
      buildWhen: (previous, current) => previous.password != current.password,
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
                const Icon(Icons.lock_rounded, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    obscureText: _passVisibility,
                    enableSuggestions: false,
                    autocorrect: false,
                    key: const Key('signuForm_passwordInput_textField'),
                    onChanged: (password) => context
                        .read<ForgotAheadBloc>()
                        .add(ForgotPasswordChanged(password)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.visiblePassword,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.6)),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: _passVisibility
                            ? const Icon(
                                size: 20,
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                size: 20,
                                Icons.visibility,
                                color: Colors.black,
                              ),
                        onPressed: () {
                          _toggleVisibility();
                        },
                      ),
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

class BuildPassword2 extends StatefulWidget {
  const BuildPassword2({super.key});

  @override
  State<BuildPassword2> createState() => _BuildPassword2();
}

class _BuildPassword2 extends State<BuildPassword2> {
  bool _passVisibility = true;

  void _toggleVisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
      buildWhen: (previous, current) => previous.password2 != current.password2,
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
                const Icon(Icons.lock_rounded, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    obscureText: _passVisibility,
                    enableSuggestions: false,
                    autocorrect: false,
                    key: const Key('signuForm_passwordInput_textField'),
                    onChanged: (password) => context
                        .read<ForgotAheadBloc>()
                        .add(ForgotPassword2Changed(password)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.visiblePassword,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Repeat Password",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.6)),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: _passVisibility
                            ? const Icon(
                                size: 20,
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                size: 20,
                                Icons.visibility,
                                color: Colors.black,
                              ),
                        onPressed: () {
                          _toggleVisibility();
                        },
                      ),
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

class ChangeButton extends StatelessWidget {
  const ChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotAheadBloc, ForgotAheadState>(
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
                      key: const Key('signupForm_continue_raisedButton'),
                      onPressed: state.isValid
                          ? () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              context
                                  .read<ForgotAheadBloc>()
                                  .add(const ForgotSubmitted());
                            }
                          : null,
                      child: Center(
                        child: utext(
                          title: "Reset password",
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
