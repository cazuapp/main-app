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

import 'package:cazuapp/bloc/cart/order_add/bloc.dart';
import 'package:cazuapp/bloc/cart/order_add/state.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/progress.dart';

import 'package:cazuapp/views/cart/order_info.dart';
import 'package:cazuapp/views/orders/orders_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import '../../bloc/cart/cart_list/bloc.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage(
      {super.key, required this.address, required this.payment});

  final int address;
  final int payment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderAddBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(PlaceOrder(address: address, payment: 1)),
      child: const OrderDataForm(),
    );
  }
}

class OrderDataForm extends StatelessWidget {
  const OrderDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocBuilder<OrderAddBloc, OrderPlaceState>(
        builder: (context, state) {
      context.read<CartListBloc>().add(QuietReset());

      switch (state.status) {
        case OrderStatus.loading:
          return const Loader();
        case OrderStatus.initial:
          return const SizedBox.shrink();
        case OrderStatus.failure:
          return const FailurePage(
              title: "Error", subtitle: "Unable to add order.");
        case OrderStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: const TopBar(title: "Order on its way!"),
              body: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.04),
                          child: SingleChildScrollView(
                              child: Column(children: [
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "Order placed",
                                    color: AppTheme.title,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
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
                                    child: SingleChildScrollView(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                          const SizedBox(height: 25),
                                          const Icon(FontAwesomeIcons.store,
                                              size: 42,
                                              color: AppTheme.primarycolor),
                                          const SizedBox(height: 25),
                                          utext(
                                              title:
                                                  "Your order is on its way!",
                                              textAlign: TextAlign.center,
                                              align: Alignment.center,
                                              fontWeight: FontWeight.w700),
                                          const SizedBox(height: 15),
                                        ])))),
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "Order details",
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
                                              input: "Order ID",
                                              title: state.order.id.toString(),
                                              iconsrc: FontAwesomeIcons.info,
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            OrderInfoPage(
                                                                id: state.order
                                                                    .id)));
                                              }),
                                          ItemExtended(
                                            input: "Created",
                                            title: state.order.created,
                                            iconsrc: FontAwesomeIcons.calendar,
                                          ),
                                          const ItemExtended(
                                            input: "Order Status",
                                            title: "Placed",
                                            iconsrc: FontAwesomeIcons.store,
                                          ),
                                          ItemExtended(
                                              input: "View all orders",
                                              title:
                                                  "See all your past and current orders",
                                              iconsrc: FontAwesomeIcons.car,
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            const OrderListPage()));
                                              }),
                                        ]))),
                          ]))))));
      }
    });
  }
}
