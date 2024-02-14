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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/address/address_manager/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import 'address_list.dart';

class DeleteAddressConfirmPage extends StatelessWidget {
  final int id;
  final String name;
  const DeleteAddressConfirmPage(
      {required this.id, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AddressManagerBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance),
        child: CloseAddressForm(id: id, name: name),
      ),
    );
  }
}

class CloseAddressForm extends StatelessWidget {
  const CloseAddressForm({required this.id, required this.name, super.key});

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<AddressManagerBloc, AddressManagerState>(
        listener: (context, state) {
          if (state.current == AddressStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));
          } else {
            if (state.current == AddressStatus.success) {
              BlocProvider.of<AddressManagerBloc>(context)
                  .add(const AddressManagerOK());
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddressListPage()));
            }
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.mainbg,
            appBar: TopBar(title: "Delete address: $name"),
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.12,
                            vertical: size.height * 0.06),
                        child: Column(children: [
                          const SizedBox(height: 26),
                          const Icon(FontAwesomeIcons.triangleExclamation,
                              size: 60, color: AppTheme.softred),
                          Expanded(
                              flex: 0,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 35),
                                    utext(
                                        title: "Warning",
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.main,
                                        fontSize: 22,
                                        align: Alignment.center),
                                    const SizedBox(height: 15),
                                    utext(
                                        title:
                                            "If you remove this address, you will not be able to shop to this address again.",
                                        fontSize: 15,
                                        textAlign: TextAlign.center,
                                        color: const Color.fromARGB(
                                            159, 18, 18, 18),
                                        align: Alignment.center),
                                    const SizedBox(height: 25),
                                    utext(
                                      align: Alignment.center,
                                      textAlign: TextAlign.center,
                                      title:
                                          "Do you really want to remove this address?",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color:
                                          const Color.fromARGB(159, 18, 18, 18),
                                    ),
                                    const SizedBox(height: 25),
                                    ConfirmButton(id: id),
                                  ]))
                        ]))))));
  }
}

class ConfirmButton extends StatefulWidget {
  const ConfirmButton({required this.id, super.key});
  final int id;

  @override
  State<ConfirmButton> createState() => _CartListState();
}

class _CartListState extends State<ConfirmButton> {
  late CartListBloc cart;

  @override
  void initState() {
    super.initState();
    cart = context.read<CartListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressManagerBloc, AddressManagerState>(
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                icon: const Icon(
                  FontAwesomeIcons.rightLong,
                  color: AppTheme.mainbg,
                  size: 19.0,
                ),
                label: utext(
                    title: "Delete Address",
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mainbg),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 10.0,
                  backgroundColor: AppTheme.softred,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  cart.add(CartListPre());

                  context
                      .read<AddressManagerBloc>()
                      .add(AddressDelete(id: widget.id));
                }));
      },
    );
  }
}
