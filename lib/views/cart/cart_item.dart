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

import 'package:cazuapp/views/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../bloc/cart/cart_list/bloc.dart';
import '../../components/utext.dart';
import '../../core/theme.dart';
import '../../models/cart_item.dart';

class ListTileItem extends StatefulWidget {
  const ListTileItem({required this.item, super.key});
  final CartItem item;

  @override
  // ignore: library_private_types_in_public_api
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartListBloc, CartListState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: const Color.fromARGB(255, 242, 241, 241),
            border: Border.all(
              color: AppTheme.white,
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    color: AppTheme.subprimarycolor,
                  ),
                  child: IconButton(
                      splashRadius: 16,
                      constraints: const BoxConstraints(),
                      iconSize: 12,
                      padding: EdgeInsets.zero,
                      color: AppTheme.white,
                      icon: const Icon(FontAwesomeIcons.minus),
                      onPressed: () => {
                            context
                                .read<CartListBloc>()
                                .add(UpdateOp(op: false, item: widget.item)),
                            context.read<CartListBloc>().add(CartListPre()),
                          }),
                ),
                SizedBox(
                    width: 32,
                    child: utext(
                        align: Alignment.center,
                        title: widget.item.qty.toString(),
                        fontWeight: state.counter > 0
                            ? FontWeight.w800
                            : FontWeight.w500)),
                Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                      color: AppTheme.subprimarycolor,
                    ),
                    child: IconButton(
                        splashRadius: 16,
                        color: AppTheme.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 12,
                        icon: const Icon(FontAwesomeIcons.plus),
                        onPressed: () => {
                              context
                                  .read<CartListBloc>()
                                  .add(UpdateOp(op: true, item: widget.item)),
                              context.read<CartListBloc>().add(CartListPre()),
                            }))
              ]));
    });
  }
}

class CartDisplay extends StatelessWidget {
  const CartDisplay({required this.cart, super.key});
  final CartItem cart;

  @override
  Widget build(BuildContext context) {
    return CartItemDisplay(cart: cart);
  }
}

class CartItemDisplay extends StatefulWidget {
  final CartItem cart;

  const CartItemDisplay({required this.cart, super.key});

  @override
  State<CartItemDisplay> createState() => _CartForm();
}

class _CartForm extends State<CartItemDisplay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartListBloc, CartListState>(builder: (context, state) {
      final size = MediaQuery.of(context).size;

      var total = widget.cart.qty * widget.cart.item.price;
      final fixed = ScreenUtil().scaleWidth;

      return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductDetailPage(id: widget.cart.base.id)));
          },
          child: Padding(
            padding: EdgeInsets.only(
                top: size.width * 0.01,
                bottom: size.height * 0.01,
                left: size.height * 0.01,
                right: size.height * 0.01),
            child: Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              height: ScreenUtil().setHeight(120),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: ScreenUtil().setHeight(120),
                    width: ScreenUtil().setWidth(90),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 3.0)
                        ],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0)),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.cart.item.images.first.image),
                            fit: BoxFit.fitHeight,
                            onError: (error, stackTrace) =>
                                const AssetImage('assets/null.png'))),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: fixed * 15, left: 15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.00,
                                    bottom: size.height * 0.00,
                                    top: size.height * 0.00),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: size.width * 0.00,
                                          bottom: size.height * 0.01,
                                          left: size.height * 0.00,
                                          right: size.height * 0.03),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: utext(
                                                        fontSize: fixed * 15,
                                                        title: widget
                                                            .cart.item.title,
                                                        color: AppTheme.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  utext(
                                                      fontSize: fixed * 14,
                                                      title:
                                                          "\$${widget.cart.item.price.toString()}",
                                                      color: AppTheme.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  const SizedBox(height: 8),
                                                  ListTileItem(
                                                      item: widget.cart),
                                                ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              size.width * 0.00,
                                                          bottom: size.height *
                                                              0.00,
                                                          top: size.height *
                                                              0.00),
                                                      child: InkWell(
                                                        child: const Tooltip(
                                                            message: "Remove",
                                                            child: Icon(
                                                                size: 18,
                                                                FontAwesomeIcons
                                                                    .trash,
                                                                color: AppTheme
                                                                    .alert)),
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      CartListBloc>(
                                                                  context)
                                                              .add(CartListDelete(
                                                                  widget.cart));

                                                          BlocProvider.of<
                                                                  CartListBloc>(
                                                              context)
                                                            ..add(
                                                                CartListReset())
                                                            ..add(
                                                                CartListFetch())
                                                            ..add(
                                                                CartListPre());

                                                          int total = BlocProvider
                                                                  .of<CartListBloc>(
                                                                      context)
                                                              .instance
                                                              .cart
                                                              .items
                                                              .length;
                                                          if (total == 0) {
                                                            BlocProvider.of<
                                                                        CartListBloc>(
                                                                    context)
                                                                .add(
                                                                    CartListReset());
                                                          }
                                                        },
                                                      )),
                                                  const SizedBox(height: 15),
                                                  utext(
                                                      fontSize: fixed * 15,
                                                      title: "Total",
                                                      color: AppTheme.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  utext(
                                                      fontSize: fixed * 14,
                                                      title:
                                                          "\$${total.toStringAsFixed(2).toString()}",
                                                      textAlign: TextAlign.left,
                                                      align:
                                                          Alignment.bottomLeft,
                                                      color: AppTheme.orange,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ]),
                                          ]))
                                ])),
                            const SizedBox(height: 2),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
