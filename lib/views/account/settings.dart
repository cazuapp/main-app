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
import 'package:cazuapp/views/account/passwd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/item_full.dart';
import '../../../components/request.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import 'account_update.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsForm());
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsForm();
  }
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Settings"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: context.select(
                                        (AuthenticationBloc bloc) =>
                                            bloc.instance.getuser.first),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ItemExtended(
                                          input: "First name",
                                          title: context.select(
                                              (AuthenticationBloc bloc) =>
                                                  bloc.instance.getuser.first),
                                          fawesome: FontAwesomeIcons.person,
                                          onTap: () => {
                                                navigate(
                                                    context,
                                                    AccountUpdatePage(
                                                        iconsrc:
                                                            FontAwesomeIcons
                                                                .person,
                                                        title: "First name",
                                                        value: context
                                                            .read<
                                                                AuthenticationBloc>()
                                                            .instance
                                                            .getuser
                                                            .first,
                                                        type: LocalKeyEvent
                                                            .first))
                                              }),
                                      ItemExtended(
                                          input: "Last name",
                                          title: context
                                              .read<AuthenticationBloc>()
                                              .instance
                                              .getuser
                                              .last,
                                          iconsrc: FontAwesomeIcons.signature,
                                          onTap: () => {
                                                navigate(
                                                    context,
                                                    AccountUpdatePage(
                                                        title: "Last name",
                                                        iconsrc: Icons.person,
                                                        value: context
                                                            .read<
                                                                AuthenticationBloc>()
                                                            .instance
                                                            .getuser
                                                            .last,
                                                        type:
                                                            LocalKeyEvent.last))
                                              }),
                                      ItemExtended(
                                          input: "Email",
                                          title: context.select(
                                              (AuthenticationBloc bloc) =>
                                                  bloc.instance.getuser.email),
                                          fawesome: FontAwesomeIcons.inbox,
                                          onTap: () => {
                                                navigate(
                                                    context,
                                                    AccountUpdatePage(
                                                        title: "Email",
                                                        iconsrc: Icons
                                                            .email_outlined,
                                                        value: context
                                                            .read<
                                                                AuthenticationBloc>()
                                                            .instance
                                                            .getuser
                                                            .email,
                                                        type: LocalKeyEvent
                                                            .email))
                                              }),
                                      ItemExtended(
                                          input: "Phone",
                                          title: context
                                              .read<AuthenticationBloc>()
                                              .instance
                                              .getuser
                                              .phone,
                                          iconsrc: Icons.phone,
                                          onTap: () => {
                                                navigate(
                                                    context,
                                                    AccountUpdatePage(
                                                        title: "Phone",
                                                        iconsrc: Icons.phone,
                                                        value: context
                                                            .read<
                                                                AuthenticationBloc>()
                                                            .instance
                                                            .getuser
                                                            .phone,
                                                        type: LocalKeyEvent
                                                            .phone))
                                              }),
                                      ItemFull(
                                          bold: true,
                                          input: "Password",
                                          iconsrc: Icons.lock_outline_rounded,
                                          onTap: () => {
                                                navigate(
                                                    context, const PasswdPage())
                                              }),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )))));
    });
  }
}
