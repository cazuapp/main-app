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
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:cazuapp/views/cart/order_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/orders/orders_manager/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class OrderCancelPage extends StatelessWidget {
  final int id;

  const OrderCancelPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderManagerBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(OrderInfoRequest(id: id)),
      child: const CancelForm(),
    );
  }
}

class CancelForm extends StatelessWidget {
  const CancelForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final fixed = ScreenUtil().scaleHeight * 1.33;

    return BlocListener<OrderManagerBloc, OrderManagerState>(
        listener: (context, state) {
      if (state.current == OrderStatus.failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildAlert(state.errmsg));
      } else if (state.current == OrderStatus.cancelsuccess) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        navigate(context, OrderInfoPage(id: state.info.id));
      }
    }, child: BlocBuilder<OrderManagerBloc, OrderManagerState>(
            builder: (context, state) {
      OrderInfo order = state.info;

      bool canCancel = false;

      if (order.deliverStatus == "pending" && order.orderStatus == "pending") {
        canCancel = true;
      }
      return Scaffold(
          backgroundColor: AppTheme.mainbg,
          appBar: TopBar(title: "Cancel order #${state.info.id}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height / 1.5,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.cartShopping,
                                size: 60, color: AppTheme.remove),
                            Expanded(
                                flex: 0,
                                child: Column(children: [
                                  SizedBox(height: fixed * 20),
                                  utext(
                                      title: "Order #${state.info.id}",
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.main,
                                      fontSize: 22,
                                      align: Alignment.center),
                                  SizedBox(height: fixed * 20),
                                  canCancel
                                      ? utext(
                                          textAlign: TextAlign.center,
                                          align: Alignment.center,
                                          title:
                                              "Do you really want to cancel your order?",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppTheme.black,
                                        )
                                      : utext(
                                          textAlign: TextAlign.center,
                                          align: Alignment.center,
                                          title:
                                              "You can't cancel this order! ",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: const Color.fromARGB(
                                              159, 18, 18, 18)),
                                  const SizedBox(height: 25),
                                  canCancel
                                      ? const ConfirmButton()
                                      : const SizedBox.shrink(),
                                ]))
                          ])))));
    }));
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderManagerBloc, OrderManagerState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: ScreenUtil().scaleHeight * 50,
            width: ScreenUtil().scaleWidth * 500,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(ScreenUtil().scaleHeight * 50),
                  elevation: 0,
                  backgroundColor: AppTheme.remove,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  context
                      .read<OrderManagerBloc>()
                      .add(OrderCancelRequest(id: state.info.id));
                },
                child: Center(
                  child: utext(
                      title: "Cancel",
                      textAlign: TextAlign.center,
                      align: Alignment.center,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mainbg),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
