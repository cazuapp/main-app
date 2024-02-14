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

import 'package:cazuapp/components/item_extended.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/user/auth/bloc.dart';

import '../../../components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class AddressHistoricDataPage extends StatelessWidget {
  final int id;

  const AddressHistoricDataPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => OrderManagerBloc(
                instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(OrderInfoRequest(id: id))),
      ],
      child: const AddressHistoricDataForm(),
    );
  }
}

class AddressHistoricDataForm extends StatelessWidget {
  const AddressHistoricDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderManagerBloc, OrderManagerState>(
        builder: (context, state) {
      switch (state.current) {
        case OrderStatus.cancelsuccess:
          return const Loader();

        case OrderStatus.loading:
          return const Loader();

        case OrderStatus.success:
          return const FetchSuccess();

        case OrderStatus.initial:
          return const Loader();

        case OrderStatus.failure:
          return const Loader();
      }
    });
  }
}

class FetchSuccess extends StatefulWidget {
  const FetchSuccess({super.key});

  @override
  State<FetchSuccess> createState() => _FetchSuccessState();
}

class _FetchSuccessState extends State<FetchSuccess> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<OrderManagerBloc, OrderManagerState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: TopBar(title: state.info.addressName),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const SizedBox(height: 10),
                        Container(
                            alignment: Alignment.topLeft,
                            child: utext(
                                fontSize: 14,
                                title: state.info.addressName,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ItemExtended(
                                    input: "Name",
                                    title: state.info.addressName,
                                    iconsrc: Icons.location_history_outlined,
                                  ),
                                  ItemExtended(
                                    input: "Address",
                                    title: state.info.addressAddress,
                                    iconsrc: FontAwesomeIcons.locationArrow,
                                  ),
                                  ItemExtended(
                                    input: "City",
                                    title: state.info.addressCity,
                                    fawesome: FontAwesomeIcons.city,
                                  ),
                                  ItemExtended(
                                    input: "Zip",
                                    title: state.info.addressZip,
                                    iconsrc: Icons.numbers_rounded,
                                  ),
                                  state.info.addressOptions.isNotEmpty
                                      ? ItemExtended(
                                          input: "Options",
                                          title: state.info.addressOptions,
                                          iconsrc: Icons.adjust_outlined)
                                      : const SizedBox.shrink(),
                                  state.info.addressCommentary.isNotEmpty
                                      ? ItemExtended(
                                          input: "Commentary",
                                          title: state.info.addressCommentary,
                                          iconsrc: Icons.comment_bank_outlined,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )),
                      ]))))));
    });
  }
}
