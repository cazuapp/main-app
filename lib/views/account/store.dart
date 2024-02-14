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

import 'package:cazuapp/bloc/user/user_info/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../components/etc.dart';
import '../../../components/iconextended.dart';
import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => UserInfoBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(const LoadBase()),
        child: const StorePageForm(),
      ),
    );
  }
}

class StorePageForm extends StatelessWidget {
  const StorePageForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      String? facebook = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'facebook'));
      String? instagram = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'instagram'));
      String? url = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'url'));
      String? twitter = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'twitter'));
      String? name = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'storename'));
      String? current = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'orders'));
      String? phone = context.select((AuthenticationBloc bloc) =>
          bloc.instance.settings.getValue(key: 'phone'));

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Store", self: true),
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
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: name!,
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
                                          ItemExtended(
                                              input: "Store",
                                              title: name,
                                              fawesome: FontAwesomeIcons.store),
                                          IconExtended(
                                            input: "Store status",
                                            title: Etc.fromstring(current!) == 1
                                                ? "Accepting orders"
                                                : "Store closed",
                                            status: Etc.fromstring(current),
                                          ),
                                          ItemExtended(
                                              input: "Address",
                                              title: context.select(
                                                  (AuthenticationBloc bloc) => bloc
                                                      .instance.settings
                                                      .getValue(
                                                          key:
                                                              'store_address')),
                                              fawesome: FontAwesomeIcons
                                                  .locationArrow),
                                          ItemExtended(
                                              input: "Email",
                                              title: context.select(
                                                  (AuthenticationBloc bloc) =>
                                                      bloc.instance.settings
                                                          .getValue(
                                                              key: 'contact')),
                                              fawesome: FontAwesomeIcons.inbox),
                                          ItemExtended(
                                              external: true,
                                              input: "Phone",
                                              title: context.select(
                                                  (AuthenticationBloc bloc) =>
                                                      bloc
                                                          .instance.settings
                                                          .getValue(
                                                              key: 'phone')),
                                              onTap: () => {
                                                    Etc.launchPhone(dest: phone)
                                                  },
                                              iconsrc: Icons.phone_enabled),
                                          url!.isNotEmpty
                                              ? ItemExtended(
                                                  external: true,
                                                  input: "Website",
                                                  onTap: () => {
                                                        Etc.launchURL(
                                                            base: url, dest: '')
                                                      },
                                                  title: context.select(
                                                      (AuthenticationBloc
                                                              bloc) =>
                                                          bloc.instance.settings
                                                              .getValue(
                                                                  key: 'url')),
                                                  fawesome:
                                                      FontAwesomeIcons.chrome)
                                              : const SizedBox.shrink(),
                                          instagram!.isNotEmpty
                                              ? ItemExtended(
                                                  external: true,
                                                  input: "Instagram",
                                                  onTap: () => {
                                                        Etc.launchURL(
                                                            base:
                                                                "http://www.instagram.com",
                                                            dest: instagram)
                                                      },
                                                  title: instagram,
                                                  fawesome: FontAwesomeIcons
                                                      .instagram)
                                              : const SizedBox.shrink(),
                                          twitter!.isNotEmpty
                                              ? ItemExtended(
                                                  external: true,
                                                  input: "Twitter",
                                                  onTap: () => {
                                                        Etc.launchURL(
                                                            base:
                                                                "http://www.twitter.com",
                                                            dest: twitter)
                                                      },
                                                  title: twitter,
                                                  fawesome:
                                                      FontAwesomeIcons.twitter)
                                              : const SizedBox.shrink(),
                                          facebook!.isNotEmpty
                                              ? ItemExtended(
                                                  external: true,
                                                  input: "Facebook",
                                                  onTap: () => {
                                                        Etc.launchURL(
                                                            base:
                                                                "http://www.facebook.com",
                                                            dest: facebook)
                                                      },
                                                  title: facebook,
                                                  fawesome:
                                                      FontAwesomeIcons.facebook)
                                              : const SizedBox.shrink(),
                                        ]))),
                          ],
                        ),
                      )))));
    });
  }
}
