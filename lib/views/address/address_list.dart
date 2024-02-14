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
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/views/address/address_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/address/addresses/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';

import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';
import '../../components/navigator.dart';
import 'address_item.dart';

class AddressListPage extends StatelessWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /* We retrieve all bans on page opening */
        BlocProvider(
            create: (_) => AddressBloc(
                instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(AddressList()))
      ],
      child: const AddressHomeList(),
    );
  }
}

class AddressHomeList extends StatefulWidget {
  const AddressHomeList({super.key});

  @override
  State<AddressHomeList> createState() => AddressHomeListDisplay();
}

class AddressHomeListDisplay extends State<AddressHomeList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onHomeScroll);
  }

  Widget _description() {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              utext(
                  title: "Addresses",
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
              utext(
                  title: "${state.total.toString()} in total",
                  fontWeight: FontWeight.w300,
                  fontSize: 16)
            ],
          ));
    });
  }

  Widget addButton() {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 12),
              SizedBox(
                  height: ScreenUtil().scaleHeight * 50,
                  width: ScreenUtil().scaleWidth * 150,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.white,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size.fromHeight(ScreenUtil().scaleHeight * 50),
                        elevation: 0,
                        backgroundColor: AppTheme.primarycolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      key: const Key('signupForm_continue_raisedButton'),
                      onPressed: () {
                        navigate(context, const AddressAddPage());
                      },
                      child: Center(
                        child: utext(
                          title: "Add new",
                          textAlign: TextAlign.center,
                          align: Alignment.center,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.mainbg,
                        ),
                      ),
                    ),
                  ))
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = "Address list";

    final size = MediaQuery.of(context).size;
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      switch (state.status) {
        case AddressStatus.initial:
          return const Loader();

        case AddressStatus.loading:
          return const Loader();
        case AddressStatus.failure:
          return FailurePage(title: title, subtitle: "Error loading addresses");
        case AddressStatus.success:
          return Scaffold(
              appBar: TopBar(title: title),
              backgroundColor: AppTheme.white,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor:
                        Colors.transparent, // transparent status bar
                    statusBarIconBrightness:
                        Brightness.dark, // status bar icons' color
                  ),
                  child: SafeArea(
                      child: SizedBox(
                          height: size.height,
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.width * 0.03,
                                    bottom: size.height * 0.01,
                                    left: size.height * 0.03,
                                    right: size.height * 0.03),
                                child: Column(children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [_description(), addButton()]),
                                ])),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.addresses.length
                                              ? const SizedBox.shrink()
                                              : AddressListItem(
                                                  address:
                                                      state.addresses[index]),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax
                                          ? state.addresses.length
                                          : state.addresses.length + 1,
                                      controller: _scrollController,
                                    )))
                          ])))));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onHomeScroll)
      ..dispose();
    super.dispose();
  }

  void _onHomeScroll() {
    if (_isBottom) {
      context.read<AddressBloc>().add(AddressList());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
