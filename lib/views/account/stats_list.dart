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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../bloc/user/login/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import '../address/address_list.dart';
import '../favorites/favorites_list.dart';
import '../orders/orders_list.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(const StatsFetch()),
        child: const StatsForm(),
      ),
    );
  }
}

class StatsForm extends StatelessWidget {
  const StatsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Stats"),
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
                                    title: "Stats",
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
                                          input: "Total orders",
                                          title: context.select(
                                              (LoginBloc bloc) => bloc.instance
                                                  .statsdetails.totalOrders
                                                  .toString()),
                                          iconsrc: Icons.account_balance,
                                          onTap: () => {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            const OrderListPage())),
                                              }),
                                      ItemExtended(
                                          input: "Total addresses",
                                          title: context.select(
                                              (LoginBloc bloc) => bloc.instance
                                                  .statsdetails.totalAddress
                                                  .toString()),
                                          iconsrc:
                                              FontAwesomeIcons.locationArrow,
                                          onTap: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddressListPage())),
                                              }),
                                      ItemExtended(
                                          input: "Total favorites",
                                          title: context.select(
                                              (LoginBloc bloc) => bloc.instance
                                                  .statsdetails.totalFavorites
                                                  .toString()),
                                          iconsrc: Icons.favorite,
                                          onTap: () => {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            const FavoritesPage())),
                                              }),
                                      ItemExtended(
                                        input: "Total spent",
                                        title:
                                            "\$${context.select((LoginBloc bloc) => bloc.instance.statsdetails.totalSum.toString())}",
                                        iconsrc: Icons.numbers_outlined,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )))));
    });
  }
}
