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

import 'package:badges/badges.dart' as badges;
import 'package:cazuapp/bloc/cart/cart_list/bloc.dart';

import 'package:cazuapp/components/tabs.dart';
import 'package:cazuapp/views/collections/collection_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/utext.dart';
import '../core/theme.dart';
import 'account/account.dart';
import 'cart/checkout.dart';
import 'home/home.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MenuPage());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuForm(),
    );
  }
}

class MenuForm extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();

  MenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartListBloc, CartListState>(builder: (context, state) {
      int cartBadgeAmount = state.items.length;

      return PersistentBottomBarScaffold(
        items: [
          PersistentTabItem(
            tab: const HomePage(),
            icon: const Icon(FontAwesomeIcons.house),
            title: 'Home',
            navigatorkey: _tab1navigatorKey,
          ),
          PersistentTabItem(
            tab: const CollectionPage(),
            icon: const Icon(FontAwesomeIcons.folderOpen),
            title: 'Collections',
            //  navigatorkey: _tab2navigatorKey,
          ),
          PersistentTabItem(
            tab: const CheckoutPage(),
            title: 'Cart',
            icon: cartBadgeAmount > 0
                ? badges.Badge(
                    position: badges.BadgePosition.topEnd(),
                    badgeStyle: const badges.BadgeStyle(
                        padding: EdgeInsets.all(4),
                        badgeColor: AppTheme.lockeye2),
                    badgeContent: utext(
                      fontSize: 13,
                      title: cartBadgeAmount.toString(),
                      fontWeight: FontWeight.w400,
                      color: AppTheme.white,
                    ),
                    child: const Icon(FontAwesomeIcons.cartShopping),
                  )
                : const Icon(FontAwesomeIcons.cartShopping),
            //  navigatorkey: _tab3navigatorKey,
          ),
          PersistentTabItem(
            tab: const AccountPage(),
            icon: const Icon(FontAwesomeIcons.solidUser),
            title: 'Account',
            //  navigatorkey: _tab4navigatorKey,
          ),
        ],
      );
    });
  }
}
