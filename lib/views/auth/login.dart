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
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/views/auth/forgot.dart';
import 'package:cazuapp/views/auth/signup.dart';
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
import '../../bloc/user/login/bloc.dart';
import '../../components/utext.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (_) => LoginBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance,
        ),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  Widget registerButton() {
    return BlocBuilder<LoginBloc, LoginState>(
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
                    title: "Don't have an account?",
                    color: AppTheme.black, // Adjust the color as needed
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.center,
                    align: Alignment.center),
                const SizedBox(height: 1), // Space between texts
                utext(
                    title: "Sign Up!",
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenHeight = ScreenUtil().scaleHeight;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          String? errmsg = state.errmsg;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(buildAlert(errmsg));

          BlocProvider.of<LoginBloc>(context).add(LoginProgress(
            email: state.email,
            password: state.password,
            remember: state.remember,
          ));
        } else if (state.status.isSuccess) {
          BlocProvider.of<LoginBloc>(context).add(const LoginEventOK());
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
                                    title: "Login",
                                    fontSize: ScreenUtil().setSp(17.0),
                                  ),
                                  const BuildEmail(),
                                  SizedBox(height: screenHeight * 17),
                                  const BuildPassword(),
                                  SizedBox(height: screenHeight * 20),
                                  const BuildRemember(),
                                  SizedBox(height: screenHeight * 20),
                                  const LoginButton(),
                                  SizedBox(height: screenHeight * 20),
                                  registerButton(),
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
    return BlocBuilder<LoginBloc, LoginState>(
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
                    cursorColor: AppTheme.black,
                    key: const Key('loginForm_emailInput_textField'),
                    onChanged: (email) =>
                        context.read<LoginBloc>().add(LoginEmailChanged(email)),
                    maxLines: 1,
                    autofocus: true,
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
    return BlocBuilder<LoginBloc, LoginState>(
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
                    cursorColor: AppTheme.black,
                    obscureText: _passVisibility,
                    enableSuggestions: false,
                    autocorrect: false,
                    key: const Key('loginForm_passwordInput_textField'),
                    onChanged: (password) => context
                        .read<LoginBloc>()
                        .add(LoginPasswordChanged(password)),
                    maxLines: 1,
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

class BuildRemember extends StatelessWidget {
  const BuildRemember({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.remember != current.remember,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(18.0),
                height: ScreenUtil().setHeight(29.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: const LinearGradient(
                    begin: Alignment(5.65, -1.0),
                    end: Alignment(-1.0, 1.94),
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(123, 255, 255, 255)
                    ],
                  ),
                ),
                child: Checkbox(
                  checkColor: AppTheme.main,
                  activeColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const BorderSide(color: AppTheme.main);
                      }
                      return const BorderSide(color: AppTheme.darkset);
                    },
                  ),
                  value: state.remember,
                  onChanged: (bool? value) {
                    context.read<LoginBloc>().add(LoginRememberChanged(value!));
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read<LoginBloc>()
                      .add(LoginRememberChanged(!state.remember));
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    top: ScreenUtil().setHeight(0),
                  ),
                  child: utext(
                    title: 'Stay logged',
                    fontSize: ScreenUtil().setSp(15.0),
                    color: AppTheme.black,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  navigate(context, const ForgotPage());
                },
                child: utext(
                  title: 'Recover',
                  fontSize: 15,
                  color: AppTheme.black,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        });
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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
                                  .read<LoginBloc>()
                                  .add(const LoginSubmitted());
                            }
                          : null,
                      child: Center(
                        child: utext(
                          title: "Login",
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
