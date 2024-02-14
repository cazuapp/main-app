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

import 'package:cazuapp/components/authhead.dart';
import 'package:cazuapp/signup/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cazuapp/views/auth/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../bloc/user/auth/bloc.dart';
import '../../components/utext.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (_) => SignupBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance,
        ),
        child: const SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});
  /*
  Widget LoginButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return SizedBox(
          height: 100, // Adjust the height as needed
          width: 300,
          child: InkWell(
            onTap: () => navigate(context, const SignupPage()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                utext(
                    title: "Already have an account?",
                    color: AppTheme.black, // Adjust the color as needed
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.center,
                    align: Alignment.center),
                const SizedBox(height: 1), // Space between texts
                utext(
                    title: "Log me in!",
                    color: AppTheme.black, // Adjust the color as needed
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center,
                    align: Alignment.center),
              ],
            ),
          ),
        );
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenHeight = ScreenUtil().scaleHeight;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          String? errmsg = state.errmsg;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(buildAlert(errmsg));

          BlocProvider.of<SignupBloc>(context).add(SignupProgress(
              email: state.email.value,
              password: state.password.value,
              first: state.first.value,
              last: state.last.value,
              phone: state.phone.value));
        } else if (state.status.isSuccess) {
          BlocProvider.of<SignupBloc>(context).add(const SignupEventOK());
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
                                    title: "Create account",
                                    fontSize: ScreenUtil().setSp(17.0),
                                  ),
                                  const BuildEmail(),
                                  SizedBox(height: screenHeight * 17),
                                  const BuildFirst(),
                                  SizedBox(height: screenHeight * 17),
                                  const BuildLast(),
                                  SizedBox(height: screenHeight * 17),
                                  const BuildPassword(),
                                  SizedBox(height: screenHeight * 20),

                                  const RegisterButton(),
                                  //SizedBox(height: screenHeight * 20),
                                  //LoginButton(),
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

class BuildFirst extends StatelessWidget {
  const BuildFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.first != current.first,
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
                const Icon(FontAwesomeIcons.person, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    key: const Key('firstnForm_textInput_textField'),
                    onChanged: (first) => context
                        .read<SignupBloc>()
                        .add(SignupFirstChanged(first)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'First name',
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

class BuildLast extends StatelessWidget {
  const BuildLast({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.last != current.last,
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
                const Icon(FontAwesomeIcons.signature, color: Colors.black),
                SizedBox(width: ScreenUtil().setWidth(14)),
                Expanded(
                  child: TextField(
                    key: const Key('firstForm_firstInput_textField'),
                    onChanged: (last) =>
                        context.read<SignupBloc>().add(SignupLastChanged(last)),
                    maxLines: 1,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.ubuntu(
                      fontSize: ScreenUtil().setSp(14.0),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Last name',
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

class BuildEmail extends StatelessWidget {
  const BuildEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
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
                    key: const Key('signupForm_emailInput_textField'),
                    onChanged: (email) => context
                        .read<SignupBloc>()
                        .add(SignupEmailChanged(email)),
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
    return BlocBuilder<SignupBloc, SignupState>(
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
                        .read<SignupBloc>()
                        .add(SignupPasswordChanged(password)),
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

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
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
                                  .read<SignupBloc>()
                                  .add(const SignupSubmitted());
                            }
                          : null,
                      child: Center(
                        child: utext(
                          title: "Sign up",
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
