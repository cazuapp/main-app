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
import 'package:cazuapp/views/status/restrictions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../bloc/user/user_info/bloc.dart';
import '../../../components/status_check.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import 'health.dart';
import 'no_health.dart';
import 'no_restrictions.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => UserInfoBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(const UsersFetchHealth()),
        child: const StatusForm(),
      ),
    );
  }
}

class StatusForm extends StatelessWidget {
  const StatusForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Account status"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          const SizedBox(height: 36),
                          Container(
                              alignment: Alignment.topLeft,
                              child: utext(
                                  fontSize: 14,
                                  title: "Status",
                                  color: AppTheme.title,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          Expanded(
                              flex: 0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        StatusCheck(
                                            input: "Able to order",
                                            icon: context.select(
                                                    (AuthenticationBloc bloc) =>
                                                        bloc.instance.auth
                                                            .ableToOrder)
                                                ? 1
                                                : 0,
                                            iconsrc:
                                                (FontAwesomeIcons.userCheck),
                                            ok: () => {
                                                  navigate(context,
                                                      const HealthPage())
                                                },
                                            error: () => {
                                                  navigate(context,
                                                      const NoHealthPage())
                                                }),
                                        StatusCheck(
                                          input: "Restrictions",
                                          icon: context.select(
                                                  (AuthenticationBloc bloc) =>
                                                      bloc.instance.auth.health)
                                              ? 1
                                              : 0,
                                          iconsrc: (FontAwesomeIcons.key),
                                          ok: () => {
                                            navigate(context,
                                                const RestrictionsPage())
                                          },
                                          error: () => {
                                            navigate(context,
                                                const NoRestrictionsPage())
                                          },
                                        )
                                      ]))),
                        ],
                      ))))));
    });
  }
}
