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

import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/views/cart/final_checkout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/cart/cart_list/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/notfound.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import '../../components/total_item.dart';
import 'cart_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CartListState();
}

class _CartListState extends State<CheckoutPage> {
  final _scrollController = ScrollController();
  bool isBottom = false;
  void _toggle(bool sett) {
    setState(() {
      if (isBottom == sett) {
        return;
      }
      isBottom = sett;
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  Widget placeButton() {
    String placeMsg = "Checkout";

    return BlocBuilder<CartListBloc, CartListState>(
      builder: (context, state) {
        if (state.address == 0) {
          placeMsg = "Unable to place order";
        }

        return SizedBox(
            height: 45,
            width: ScreenUtil().scaleWidth * 250,
            child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(0),
                      elevation: 5.0,
                      backgroundColor: state.address > 0
                          ? AppTheme.subprimarycolor
                          : AppTheme.darkgray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    key: const Key('signupForm_continue_raisedButton'),
                    onPressed: () {
                      if (state.address > 0) {
                        navigate(context, const FinalCheckoutPage());
                      }
                    },
                    child: utext(
                        textAlign: TextAlign.center,
                        title: placeMsg,
                        align: Alignment.center,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.white))));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String nftitle = "Cart List";
    String nftext = "You have not added any items to the cart.";

    return BlocBuilder<CartListBloc, CartListState>(
      builder: (context, state) {
        int total = context.select(
            (AuthenticationBloc bloc) => bloc.instance.cart.items.length);

        bool ableToOrder = context.select(
            (AuthenticationBloc bloc) => bloc.instance.auth.ableToOrder);

        if (ableToOrder != true) {
          return const FailurePage(
              title: "Unable to place orders",
              subtitle: "You have a hold on your account");
        }

        switch (state.status) {
          case CartListStatus.failure:
            return const FailurePage(
                title: "Error", subtitle: "Unable to add order.");

          case CartListStatus.loading:
            return const Loader();

          case CartListStatus.initial:
            return NotFoundPage(title: nftitle, main: nftext);

          case CartListStatus.reload:
          case CartListStatus.success:
            if (state.items.isEmpty) {
              return NotFoundPage(title: nftitle, main: nftext);
            }
            return Scaffold(
              backgroundColor: AppTheme.white,
              bottomNavigationBar: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        placeButton(),
                      ],
                    ),
                  )),
              appBar: TopBar(title: "Cart ($total items)"),
              body: SafeArea(
                child: SizedBox(
                  height: size.height,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                            vertical: size.height * 0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      shrinkWrap: false,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.items.length
                                              ? const SizedBox.shrink()
                                              : CartDisplay(
                                                  cart: state.items[index]),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax
                                          ? state.items.length
                                          : state.items.length + 1,
                                      controller: _scrollController,
                                    ))),
                            const Divider(
                              color: AppTheme.darkset,
                              height: 3,
                              thickness: 1,
                            ),
                            TotalExtended(
                              title: "Subtotal",
                              right: (state.status == CartListStatus.reload ||
                                      state.preorder.total == 0)
                                  ? "..."
                                  : "\$${state.preorder.total.toString()}",
                            ),
                            TotalExtended(
                              title: "Tax",
                              right: (state.status == CartListStatus.reload ||
                                      state.preorder.total == 0)
                                  ? "..."
                                  : "\$${state.preorder.totalTax.toString()}",
                            ),
                            TotalExtended(
                              title: "Shipping",
                              right: (state.status == CartListStatus.reload ||
                                      state.preorder.total == 0)
                                  ? "..."
                                  : "\$${state.preorder.shipping.toString()}",
                            ),
                            TotalExtended(
                              bold: true,
                              title: "Total",
                              right: (state.status == CartListStatus.reload ||
                                      state.preorder.total == 0)
                                  ? "..."
                                  : "\$${state.preorder.total.toString()}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CartListBloc>().add(CartListFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll <= 0.9) {
      _toggle(false);
    } else {
      _toggle(true);
    }
    return currentScroll >= (maxScroll * 0.9);
  }
}
