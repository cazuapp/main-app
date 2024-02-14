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

import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/bloc/user/passwd/bloc.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/views/account/settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:formz/formz.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../components/alerts.dart';
import '../../../components/ok.dart';
import '../../../core/theme.dart';

class PasswdPage extends StatelessWidget {
  const PasswdPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PasswdPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => PasswdBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: const PasswdForm(),
      ),
    );
  }
}

class PasswdForm extends StatelessWidget {
  const PasswdForm({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<PasswdBloc, PasswdState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));

            BlocProvider.of<PasswdBloc>(context).add(PasswdProgress(
                current: state.current,
                newpass: state.newpass,
                newpass2: state.newpass2));
          } else if (state.status.isSuccess) {
            BlocProvider.of<PasswdBloc>(context).add(const PasswdEventOK());

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildOk(state.okmsg));

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          }
        },
        child: Scaffold(
            appBar: const TopBar(title: "Password change"),
            backgroundColor: AppTheme.mainbg,
            body: SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 240, 240, 240),
                      ],
                    )),
                    child: SizedBox(
                        height: size.height,
                        child: Stack(children: <Widget>[
                          Positioned(
                              child: SizedBox(
                                  child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  SizedBox(
                                    height: ScreenUtil().scaleHeight * 50,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.10),
                                        child: utext(
                                            fontSize: 14,
                                            title: "Password change",
                                            color: AppTheme.title,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(height: 6),
                                  const Expanded(
                                    flex: 0,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 6),
                                          BuildOld(),
                                          SizedBox(height: 16),
                                          BuildPassword(),
                                          SizedBox(height: 16),
                                          BuildPassword2(),
                                          SizedBox(height: 16),
                                          UpdateButton(),
                                        ],
                                      ),
                                    ),
                                  )
                                ])),
                          )))
                        ]))))));
  }
}

class BuildOld extends StatefulWidget {
  const BuildOld({super.key});

  @override
  State<BuildOld> createState() => _BuildOld();
}

class _BuildOld extends State<BuildOld> {
  bool _passVisibility = true;

  void _togglevisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PasswdBloc, PasswdState>(
      buildWhen: (previous, current) => previous.current != current.current,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.lock_sharp, color: Colors.black87),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        obscureText: _passVisibility,
                        enableSuggestions: false,
                        autocorrect: false,
                        key: const Key('SignupForm_passwordInput_textField'),
                        onChanged: (password) => context
                            .read<PasswdBloc>()
                            .add(CurrentChanged(password)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 15),
                            border: InputBorder.none,
                            hintText: "Current pasword",
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              icon: _passVisibility
                                  ? const Icon(
                                      size: 20,
                                      Icons.visibility_off,
                                      color: AppTheme.black)
                                  : const Icon(
                                      size: 20,
                                      Icons.visibility,
                                      color: AppTheme.black),
                              onPressed: () {
                                _togglevisibility();
                              },
                            )),
                      ),
                    )
                  ])),
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

  void _togglevisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PasswdBloc, PasswdState>(
      buildWhen: (previous, current) => previous.newpass != current.newpass,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.lock_open, color: Colors.black87),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        obscureText: _passVisibility,
                        enableSuggestions: false,
                        autocorrect: false,
                        key: const Key('SignupForm_passwordInput_textField'),
                        onChanged: (password) => context
                            .read<PasswdBloc>()
                            .add(NewPassChanged(password)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 15),
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              icon: _passVisibility
                                  ? const Icon(
                                      size: 20,
                                      Icons.visibility_off,
                                      color: AppTheme.black)
                                  : const Icon(
                                      size: 20,
                                      Icons.visibility,
                                      color: AppTheme.black),
                              onPressed: () {
                                _togglevisibility();
                              },
                            )),
                      ),
                    )
                  ])),
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

  void _togglevisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PasswdBloc, PasswdState>(
      buildWhen: (previous, current) => previous.newpass2 != current.newpass2,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.lock_open, color: Colors.black87),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        obscureText: _passVisibility,
                        enableSuggestions: false,
                        autocorrect: false,
                        key: const Key('SignupForm_passwordInput_textField'),
                        onChanged: (password) => context
                            .read<PasswdBloc>()
                            .add(NewPass2Changed(password)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 15),
                            border: InputBorder.none,
                            hintText: "Repeat password",
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              icon: _passVisibility
                                  ? const Icon(
                                      size: 20,
                                      Icons.visibility_off,
                                      color: AppTheme.black)
                                  : const Icon(
                                      size: 20,
                                      Icons.visibility,
                                      color: AppTheme.black),
                              onPressed: () {
                                _togglevisibility();
                              },
                            )),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PasswdBloc, PasswdState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: size.height / 14,
                width: size.width / 1.4,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          elevation: 4.0,
                          backgroundColor: AppTheme.primarycolor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        key: const Key('addForm_continue_raisedButton'),
                        onPressed: state.isValid
                            ? () {
                                context
                                    .read<PasswdBloc>()
                                    .add(const PasswdSubmitted());
                              }
                            : null,
                        child: utext(
                            title: "Update",
                            textAlign: TextAlign.center,
                            align: Alignment.center,
                            fontWeight: FontWeight.w500,
                            color: !state.isValid
                                ? AppTheme.yesArrow
                                : AppTheme.mainbg))));
      },
    );
  }
}
