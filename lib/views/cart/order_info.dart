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

import 'package:cazuapp/bloc/orders/orders_manager/bloc.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/item_account.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/models/order_info.dart';

import 'package:cazuapp/views/address/address_historic.dart';
import 'package:cazuapp/views/orders/order_cancel_request.dart';
import 'package:cazuapp/views/orders/order_items.dart';
import 'package:cazuapp/views/orders/orders_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/user/auth/bloc.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderManagerBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(OrderInfoRequest(id: id)),
        child: const OrderInfoForm(),
      ),
    );
  }
}

class OrderInfoForm extends StatelessWidget {
  const OrderInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocBuilder<OrderManagerBloc, OrderManagerState>(
        builder: (context, state) {
      bool canCancel = false;
      bool isCancelled = false;

      OrderInfo order = state.info;

      int driver = state.info.driver;

      String display = "";
      if (order.deliverStatus == "pending" && order.orderStatus == "pending") {
        canCancel = true;
      }
      switch (order.orderStatus) {
        case "pending":
          display = "Pending";

          break;

        case "delivered":
          display = "Delivered";
          break;

        case "nodriver":
          display = "Unable to match driver";

          break;

        case "active":
          display = "";

          break;

        case "cancelled":
          isCancelled = true;
          display = "Cancelled";

          break;
        default:
          display = "Error";

          break;
      }

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: const TopBar(title: "Order information"),
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
                                    title: "Order #${order.id.toString()}",
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
                                            input: "ID",
                                            title: order.id.toString(),
                                            fawesome: FontAwesomeIcons.listOl,
                                          ),
                                          ItemExtended(
                                            red: isCancelled ? true : false,
                                            input: "Order status",
                                            title: display,
                                            fawesome: FontAwesomeIcons
                                                .arrowDownUpLock,
                                          ),
                                          !isCancelled
                                              ? ItemExtended(
                                                  input: "Deliver status",
                                                  title: order.deliverStatus
                                                      .capitalize(),
                                                  fawesome:
                                                      FontAwesomeIcons.info,
                                                )
                                              : const SizedBox.shrink(),
                                          driver > 0
                                              ? ItemExtended(
                                                  input: "Driver",
                                                  title:
                                                      "${order.driverFirst} ${order.driverLast}",
                                                  fawesome:
                                                      FontAwesomeIcons.carRear,
                                                )
                                              : const SizedBox.shrink(),
                                          ItemExtended(
                                            input: "Total",
                                            title:
                                                "\$${order.total.toString()}",
                                            fawesome: FontAwesomeIcons
                                                .moneyBillTrendUp,
                                          ),
                                          ItemExtended(
                                            input: "Shipping total",
                                            title:
                                                "\$${order.shipping.toString()}",
                                            fawesome: FontAwesomeIcons
                                                .moneyBillTransfer,
                                          ),
                                          ItemExtended(
                                            input: "Total + taxes",
                                            title:
                                                "\$${order.totalTaxShipping.toString()}",
                                            fawesome:
                                                FontAwesomeIcons.moneyCheck,
                                          ),
                                          ItemAccount(
                                              title: "View all items",
                                              fawesome: FontAwesomeIcons.list,
                                              onTap: () {
                                                navigate(
                                                    context,
                                                    OrderItemsPage(
                                                        id: order.id));
                                              }),
                                          ItemExtended(
                                              input: "Address",
                                              title: order.addressName,
                                              fawesome:
                                                  FontAwesomeIcons.locationDot,
                                              onTap: () {
                                                navigate(
                                                    context,
                                                    AddressHistoricDataPage(
                                                        id: order.id));
                                              }),
                                          canCancel == true
                                              ? ItemAccount(
                                                  title: "Cancel order",
                                                  fawesome:
                                                      FontAwesomeIcons.xmark,
                                                  onTap: () {
                                                    navigate(
                                                        context,
                                                        OrderCancelPage(
                                                            id: order.id));
                                                  })
                                              : const SizedBox.shrink(),
                                        ]))),
                            const SizedBox(height: 6),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "More",
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
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ItemAccount(
                                            title: "View all orders",
                                            iconsrc: FontAwesomeIcons.car,
                                            onTap: () {
                                              navigate(context,
                                                  const OrderListPage());
                                            })
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                      )))));
    });
  }
}
