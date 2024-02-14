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

import 'package:cazuapp/bloc/cart/cart_list/bloc.dart';
import 'package:cazuapp/models/item.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/utext.dart';
import '../../../core/theme.dart';

class OrderItemList extends StatefulWidget {
  final Item item;
  final int index;

  const OrderItemList({required this.index, required this.item, super.key});

  @override
  State<OrderItemList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderItemList> {
  late CartListBloc cart;

  @override
  void initState() {
    super.initState();
    cart = context.read<CartListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.only(top: 5),
      child: Container(
          color: AppTheme.white,
          child: Table(
            border: TableBorder.symmetric(
              outside: const BorderSide(
                  width: 1, color: AppTheme.black, style: BorderStyle.solid),
              inside: const BorderSide(
                  width: 1, color: AppTheme.black, style: BorderStyle.solid),
            ),
            children: [
              TableRow(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(
                      title: widget.item.variantHistoric,
                      fontWeight: FontWeight.w600,
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(title: widget.item.quantity.toString())),
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(title: "\$${widget.item.total.toString()}"))
              ])
            ],
          )),
    );

    /*return InkWell(
        child: Container(
            color: AppTheme.mainbg,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Stack(children: <Widget>[
              GestureDetector(
                  child: ListTile(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),


                      subtitle: Column(
                            children: <Widget>[
                                                            const SizedBox(height: 4),

                              utext(title: "Quantity: ${widget.item.quantity.toString()}"),
                              const SizedBox(height: 4),
                              utext(title: "Total:  \$${widget.item.total.toString()}"),

                            ],
                          ),
                      leading: const Icon(FontAwesomeIcons.solidCircle, size: 15, color: AppTheme.iconcolors),
                      title: utext(title: widget.item.variantHistoric, fontSize: 15.0, color: AppTheme.darkgray, fontWeight: FontWeight.w700)))
            ]))
            );*/
  }
}
