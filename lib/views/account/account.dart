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
import 'package:cazuapp/views/account/settings.dart';
import 'package:cazuapp/views/account/store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';
import '../../../bloc/user/preferences/bloc.dart';
import '../../../components/etc.dart';
import '../../../components/fav_button.dart';
import '../../../components/item_account.dart';
import '../../../components/item_full.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import '../address/address_list.dart';
import '../favorites/favorites_list.dart';
import '../help/help.dart';
import '../orders/orders_list.dart';
import '../status/close.dart';
import '../status/status.dart';
import 'about.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PreferencesBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance),
      child: const AccountForm(),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: const TopBar(title: "Account"),
        body: SafeArea(
          child: SizedBox(
              height: size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14,
                              title: "Shortcuts",
                              color: AppTheme.title,
                              fontWeight: FontWeight.w500)),
                      const BuildButtons(),
                      const SizedBox(height: 6),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14,
                              title: "Account",
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
                              border:
                                  Border.all(width: 1, color: Colors.white)),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        child: Stack(children: <Widget>[
                                          GestureDetector(
                                            child: ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -1,
                                                      vertical: -1),
                                              leading: const Icon(
                                                  FontAwesomeIcons
                                                      .solidNewspaper,
                                                  color: AppTheme.black),
                                              trailing: Switch(
                                                activeColor:
                                                    AppTheme.primarycolor,
                                                inactiveThumbColor:
                                                    AppTheme.primarycolor,
                                                value: Etc.asBoolean(context
                                                    .select((AuthenticationBloc
                                                            bloc) =>
                                                        bloc.instance
                                                            .preferences
                                                            .getValue(
                                                                key:
                                                                    'offers'))),
                                                onChanged: (value) {
                                                  setState(() {
                                                    BlocProvider.of<
                                                                PreferencesBloc>(
                                                            context)
                                                        .add(SettingChanged(
                                                            key: 'offers',
                                                            value:
                                                                Etc.toBoolean(
                                                                    value)));
                                                  });
                                                },
                                              ),
                                              title: utext(
                                                title: "Receive offers",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ]))),
                                InkWell(
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        child: Stack(children: <Widget>[
                                          GestureDetector(
                                            child: ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -1,
                                                      vertical: -1),
                                              leading: const Icon(
                                                  FontAwesomeIcons.solidBell,
                                                  color: AppTheme.black),
                                              trailing: Switch(
                                                activeColor:
                                                    AppTheme.primarycolor,
                                                inactiveThumbColor:
                                                    AppTheme.primarycolor,
                                                value: Etc.asBoolean(context
                                                    .select((AuthenticationBloc
                                                            bloc) =>
                                                        bloc.instance
                                                            .preferences
                                                            .getValue(
                                                                key:
                                                                    'alerts'))),
                                                onChanged: (value) {
                                                  setState(() {
                                                    BlocProvider.of<
                                                                PreferencesBloc>(
                                                            context)
                                                        .add(SettingChanged(
                                                            key: 'alerts',
                                                            value:
                                                                Etc.toBoolean(
                                                                    value)));
                                                  });
                                                },
                                              ),
                                              title: utext(
                                                title: "Newsletter",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ]))),
                                ItemAccount(
                                    title: "Addresses",
                                    fawesome: FontAwesomeIcons.locationArrow,
                                    onTap: () => {
                                          navigate(
                                              context, const AddressListPage())
                                        }),
                                ItemAccount(
                                    title: "Store",
                                    fawesome: FontAwesomeIcons.store,
                                    onTap: () =>
                                        {navigate(context, const StorePage())}),
                                ItemAccount(
                                    title: "Help",
                                    fawesome: FontAwesomeIcons.fireExtinguisher,
                                    onTap: () =>
                                        {navigate(context, const HelpPage())}),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14,
                              title: "Session",
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
                                border:
                                    Border.all(width: 1, color: Colors.white)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 6),
                                  ItemAccount(
                                      title: "Account Status",
                                      fawesome: FontAwesomeIcons.bandage,
                                      onTap: () => {
                                            navigate(
                                                context, const StatusPage())
                                          }),
                                  ItemFull(
                                      input: "About",
                                      iconsrc: FontAwesomeIcons.circleInfo,
                                      onTap: () => {
                                            navigate(context, const AboutPage())
                                          }),
                                  ItemAccount(
                                      title: "Close Account",
                                      fawesome: FontAwesomeIcons.doorClosed,
                                      onTap: () => {
                                            navigate(context, const ClosePage())
                                          }),
                                  ItemAccount(
                                      title: "Logout",
                                      fawesome:
                                          FontAwesomeIcons.rightFromBracket,
                                      onTap: () => {
                                            context.read<AuthenticationBloc>().add(
                                                AuthenticationLogoutRequested())
                                          }),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}

class BuildButtons extends StatelessWidget {
  const BuildButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 15.0, top: 8),
          child: Stack(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.002, vertical: size.height * 0.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FavButton(
                      color: AppTheme.subprimarycolor,
                      name: "Favorites",
                      fawesome: FontAwesomeIcons.solidHeart,
                      onTap: () => {navigate(context, const FavoritesPage())}),
                  FavButton(
                      name: "Settings",
                      color: AppTheme.secondary,
                      fawesome: FontAwesomeIcons.gear,
                      onTap: () => {navigate(context, const SettingsPage())}),
                  FavButton(
                      name: "Orders",
                      color: AppTheme.fav,
                      fawesome: FontAwesomeIcons.bagShopping,
                      onTap: () => {navigate(context, const OrderListPage())})
                ],
              ),
            )
          ]));
    });
  }
}
