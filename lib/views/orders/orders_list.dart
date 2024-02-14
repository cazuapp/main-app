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
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/orders/orders_list/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/order_list_item.dart';
import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(OrderSet(request: "pending"))
        ..add(OrderFetch()),
      child: const OrderListForm(),
    );
  }
}

class OrderListForm extends StatefulWidget {
  const OrderListForm({super.key});
  @override
  State<OrderListForm> createState() => _OrderListFormState();
}

class _OrderListFormState extends State<OrderListForm> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  String? selectedValue = "Active";

  List<String> ids = ['Active', 'Past'];
  String? original = "Active";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        switch (state.status) {
          case OrderStatus.initial:
            return const Loader();

          case OrderStatus.loading:
            return const Loader();
          case OrderStatus.failure:
            return const FailurePage(
                title: "Orders list", subtitle: "Error loading orders");
          case OrderStatus.success:
            return Scaffold(
                backgroundColor: AppTheme.white,
                appBar: const TopBar(title: "Orders list"),
                body: SafeArea(
                    child: SizedBox(
                        height: size.height,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            child: Column(children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Row(
                                            children: [
                                              const Icon(
                                                Icons.list,
                                                size: 16,
                                                color: AppTheme.black,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  original!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: ids
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts.ubuntu(
                                                        fontSize: 15.0,
                                                        color: AppTheme.black,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              original = value;
                                              selectedValue = original;
                                            });

                                            if (value == "Active") {
                                              context.read<OrderBloc>()
                                                ..add(OrderSet(
                                                    request: "pending"))
                                                ..add(OrderFetch());
                                            } else {
                                              context.read<OrderBloc>()
                                                ..add(OrderSet(request: "all"))
                                                ..add(OrderFetch());
                                            }
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: 160,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: AppTheme.white,
                                            ),
                                            elevation: 2,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: AppTheme.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: AppTheme.white,
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ))),
                              const SizedBox(height: 20),
                              Expanded(
                                  //flex: 0,
                                  child: ListView.builder(
                                shrinkWrap: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: <Widget>[
                                    index >= state.orders.length
                                        ? const SizedBox.shrink()
                                        : OrderListItem(
                                            order: state.orders[index],
                                            current: state
                                                .orders[index].orderStatus),
                                  ]);
                                },
                                itemCount: state.hasReachedMax
                                    ? state.orders.length
                                    : state.orders.length + 1,
                                controller: _scrollController,
                              )),
                              const SizedBox(height: 20),
                            ])))));
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
    if (_isBottom) context.read<OrderBloc>().add(OrderFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
