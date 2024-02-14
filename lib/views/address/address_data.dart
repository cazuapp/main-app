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

import 'package:cazuapp/bloc/user/preferences/bloc.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/item_extended.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/address/address_manager/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/item_dep.dart';
import '../../../components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/request.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import 'address_update.dart';
import 'delete_confirm.dart';

class AddressDataPage extends StatelessWidget {
  final int id;

  const AddressDataPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AddressManagerBloc(
                instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(AddressAddressRequest(id))),
        BlocProvider(
            create: (_) => PreferencesBloc(
                instance:
                    BlocProvider.of<AuthenticationBloc>(context).instance)),
      ],
      child: const AddressDataForm(),
    );
  }
}

class AddressDataForm extends StatelessWidget {
  const AddressDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressManagerBloc, AddressManagerState>(
        builder: (context, state) {
      switch (state.current) {
        case AddressStatus.loading:
          return const Loader();

        case AddressStatus.success:
          return const FetchSuccess();

        case AddressStatus.initial:
          return const Loader();

        case AddressStatus.failure:
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

    return BlocBuilder<AddressManagerBloc, AddressManagerState>(
        builder: (context, state) {
      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: TopBar(title: state.address.name.value),
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
                                title: state.address.name.value,
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
                                      title: state.address.name.value,
                                      iconsrc: Icons.location_history_outlined,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "Name",
                                                    iconsrc: Icons
                                                        .location_history_outlined,
                                                    value: state
                                                        .address.name.value,
                                                    type: LocalKeyEvent.name))
                                          }),
                                  ItemExtended(
                                      input: "Address",
                                      title: state.address.address.value,
                                      iconsrc: FontAwesomeIcons.locationArrow,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "Address",
                                                    iconsrc: FontAwesomeIcons
                                                        .locationArrow,
                                                    value: state
                                                        .address.address.value,
                                                    type:
                                                        LocalKeyEvent.address))
                                          }),
                                  ItemExtended(
                                      input: "City",
                                      title: state.address.city.value,
                                      fawesome: FontAwesomeIcons.city,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "City",
                                                    iconsrc: FontAwesomeIcons
                                                        .locationArrow,
                                                    value: state
                                                        .address.city.value,
                                                    type: LocalKeyEvent.city))
                                          }),
                                  ItemExtended(
                                      input: "Zip",
                                      title: state.address.zip.value,
                                      iconsrc: Icons.numbers_rounded,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "Zip",
                                                    iconsrc:
                                                        Icons.numbers_rounded,
                                                    value:
                                                        state.address.zip.value,
                                                    type: LocalKeyEvent.zip))
                                          }),
                                  ItemExtended(
                                      input: "Options",
                                      title: state.address.options.value,
                                      iconsrc: Icons.adjust_outlined,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "Options",
                                                    iconsrc: Icons
                                                        .open_in_new_outlined,
                                                    value: state
                                                        .address.options.value,
                                                    type:
                                                        LocalKeyEvent.options))
                                          }),
                                  ItemExtended(
                                      input: "Commentary",
                                      title: state.address.commentary.value,
                                      iconsrc: Icons.comment_bank_outlined,
                                      onTap: () => {
                                            navigate(
                                                context,
                                                AddressInfoPage(
                                                    id: state.address.id,
                                                    title: "Commentary",
                                                    iconsrc: Icons
                                                        .comment_bank_rounded,
                                                    value: state.address
                                                        .commentary.value,
                                                    type: LocalKeyEvent
                                                        .commentary))
                                          }),
                                  ItemExtended(
                                    input: "Added",
                                    title: Etc.prettySmalldate(
                                        state.address.createdat),
                                    iconsrc: Icons.date_range_sharp,
                                  ),
                                ],
                              ),
                            )),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              ItemDep(
                                  bgcolor: AppTheme.softred,
                                  txtcolor: AppTheme.white,
                                  title: "Delete",
                                  fawesome: FontAwesomeIcons.xmark,
                                  onTap: () => {
                                        navigate(
                                            context,
                                            DeleteAddressConfirmPage(
                                                id: state.address.id,
                                                name: state.address.name.value))
                                      }),
                            ])
                      ]))))));
    });
  }
}
