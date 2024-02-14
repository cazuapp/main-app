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

import 'package:cazuapp/bloc/orders/item_list/bloc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/views/orders/order_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/notfound.dart';
import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';

class OrderItemsPage extends StatelessWidget {
  const OrderItemsPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderItemsBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(SetOrder(id: id))
          ..add(ItemsFetch()),
        child: const OrderItemsForm(),
      ),
    );
  }
}

class OrderItemsForm extends StatefulWidget {
  const OrderItemsForm({super.key});

  @override
  State<OrderItemsForm> createState() => OrderItemState();
}

class OrderItemState extends State<OrderItemsForm> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _description() {
    return BlocBuilder<OrderItemsBloc, OrderItemsState>(
        builder: (context, state) {
      int total = state.total;

      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              utext(
                  title: "Items on order #${state.id}",
                  color: AppTheme.main,
                  fontWeight: FontWeight.w600),
              const SizedBox(height: 2),
              utext(title: "$total in total", color: AppTheme.darkgray),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar;

    final size = MediaQuery.of(context).size;
    return BlocBuilder<OrderItemsBloc, OrderItemsState>(
        builder: (context, state) {
      switch (state.status) {
        case OrderItemsStatus.initial:
          return const Loader();
        case OrderItemsStatus.loading:
          return const Loader();

        case OrderItemsStatus.failure:
          return const FailurePage(
              title: "Items list", subtitle: "Failed to retrieve item list.");

        case OrderItemsStatus.success:
          if (state.items.isEmpty) {
            return const NotFoundPage(
                title: "Item List", main: "You have not added any items.");
          }
          return Scaffold(
              appBar: TopBar(title: "Items on order ${state.id}"),
              body: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Stack(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _description(),
                                ])),
                        const SizedBox(height: 15),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.height * 0.00),
                            child: Column(
                              children: [
                                const SizedBox(height: 90),
                                Container(
                                    color: AppTheme.white,
                                    child: Table(
                                        border: TableBorder.symmetric(
                                          outside: const BorderSide(
                                              width: 1,
                                              color: AppTheme.black,
                                              style: BorderStyle.solid),
                                          inside: const BorderSide(
                                              width: 1,
                                              color: AppTheme.black,
                                              style: BorderStyle.solid),
                                        ),
                                        children: [
                                          TableRow(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5, bottom: 5),
                                                child: utext(
                                                    title: "Item",
                                                    fontWeight: FontWeight.w600,
                                                    align: Alignment.center)),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5, bottom: 5),
                                                child: utext(
                                                    title: "Quantity",
                                                    fontWeight: FontWeight.w600,
                                                    align: Alignment.center)),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5, bottom: 5),
                                                child: utext(
                                                    title: "Price",
                                                    fontWeight: FontWeight.w600,
                                                    align: Alignment.center)),
                                          ])
                                        ])),
                                Expanded(
                                    child: ListView.builder(
                                  shrinkWrap: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(children: <Widget>[
                                      index >= state.items.length
                                          ? const SizedBox.shrink()
                                          : OrderItemList(
                                              index: index,
                                              item: state.items[index]),
                                    ]);
                                  },
                                  itemCount: state.hasReachedMax
                                      ? state.items.length
                                      : state.items.length + 1,
                                  controller: _scrollController,
                                )),
                                const SizedBox(height: 12),
                              ],
                            ))
                      ]))));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<OrderItemsBloc>().add(ItemsFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
