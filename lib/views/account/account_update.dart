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

import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/request.dart';
import 'package:cazuapp/views/account/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:formz/formz.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../bloc/user/user_info/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class AccountUpdatePage extends StatelessWidget {
  final LocalKeyEvent type;

  final String value;
  final String title;
  final IconData iconsrc;

  const AccountUpdatePage(
      {required this.type,
      required this.title,
      required this.iconsrc,
      required this.value,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(
            UsersInfoPreloadChanged(iconsrc: iconsrc, key: type, value: value)),
      child: ProductInfoForm(title: title),
    );
  }
}

class ProductInfoForm extends StatefulWidget {
  final String title;
  const ProductInfoForm({required this.title, super.key});

  @override
  State<ProductInfoForm> createState() => ProductUpdateForm();
}

class ProductUpdateForm extends State<ProductInfoForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<UserInfoBloc, UserInfoState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));
          } else if (state.status.isSuccess) {
            BlocProvider.of<UserInfoBloc>(context)
                .add(const UsersInfoEventOK());

            Navigator.pop(context);

            Navigator.pop(context);
            //Navigator.pop(context);

            navigate(context, const SettingsPage());
          }
        },
        child: Scaffold(
            appBar: TopBar(title: widget.title.toString()),
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
                                            title: widget.title,
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
                                          BuildKey(),
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

class BuildKey extends StatelessWidget {
  const BuildKey({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final LocalKeyEvent ktype =
        context.select((UserInfoBloc bloc) => bloc.state.key);

    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        TextInputType usektype = TextInputType.emailAddress;

        if (ktype == LocalKeyEvent.phone) {
          usektype = TextInputType.phone;
        } else if (ktype == LocalKeyEvent.email) {
          usektype = TextInputType.emailAddress;
        } else {
          usektype = TextInputType.text;
        }

        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        key: const Key('titleForm_firstInput_textField'),
                        onChanged: (data) => {
                          context
                              .read<UserInfoBloc>()
                              .add(UsersInfoBlocKeyChanged(data))
                        },
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: usektype,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
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

    return BlocBuilder<UserInfoBloc, UserInfoState>(
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
                                    .read<UserInfoBloc>()
                                    .add(const UsersInfoSubmitted());
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
