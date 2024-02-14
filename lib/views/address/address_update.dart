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
import 'package:cazuapp/components/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/address/address_update/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/alerts.dart';

import '../../../components/request.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';
import 'address_data.dart';

class AddressInfoPage extends StatelessWidget {
  final int id;
  final LocalKeyEvent type;
  final String value;
  final String title;
  final IconData iconsrc;

  const AddressInfoPage(
      {required this.id,
      required this.type,
      required this.title,
      required this.iconsrc,
      required this.value,
      super.key});

  Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => AddressInfoPage(
            id: id, iconsrc: iconsrc, title: title, type: type, value: value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AddressUpdateBloc(
            instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(AddressUpdatePreloadChanged(
              id: id, iconsrc: iconsrc, key: type, value: value)),
        child: AddressInfoForm(title: title),
      ),
    );
  }
}

class AddressInfoForm extends StatefulWidget {
  final String title;

  const AddressInfoForm({required this.title, super.key});

  @override
  State<AddressInfoForm> createState() => _AddressInfoForm();
}

class _AddressInfoForm extends State<AddressInfoForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocListener<AddressUpdateBloc, AddressInfoState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));
          } else if (state.status.isSuccess) {
            BlocProvider.of<AddressUpdateBloc>(context)
                .add(const AddressInfoEventOK());
            context.read<CartListBloc>().add(CartAddressReload(state.id));

            Navigator.pop(context);

            Navigator.pop(context);

            navigate(context, AddressDataPage(id: state.id));
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.white,
            appBar: TopBar(title: "Update ${widget.title}"),
            body: SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 240, 240, 240),
                      ],
                    )),
                    child: SizedBox(
                        height: size.height,
                        child: Stack(children: <Widget>[
                          Positioned(
                              child: SizedBox(
                                  child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  SizedBox(
                                    height: ScreenUtil().scaleHeight * 50,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.10),
                                        child: utext(
                                            fontSize: 14,
                                            title: widget.title,
                                            color: AppTheme.title,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(height: 6),
                                  const Expanded(
                                    flex: 0,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          BuildKey(),
                                          SizedBox(height: 16),
                                          UpdateButton(),
                                        ],
                                      ),
                                    ),
                                  )
                                ])),
                          )))
                        ]))))));
  }
}

class BuildKey extends StatelessWidget {
  const BuildKey({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressUpdateBloc, AddressInfoState>(
      builder: (context, state) {
        TextInputType usektype = TextInputType.text;

        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        key: Key(state.value),
                        initialValue: state.value,
                        onChanged: (data) => context
                            .read<AddressUpdateBloc>()
                            .add(AddressUpdateBlocKeyChanged(data)),
                        maxLines: null,
                        keyboardType: usektype,
                        cursorColor: Colors.black87,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressUpdateBloc, AddressInfoState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: size.height / 14,
                width: size.width / 1.4,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          elevation: 4.0,
                          backgroundColor: AppTheme.primarycolor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        key: const Key('addForm_continue_raisedButton'),
                        onPressed: state.isValid
                            ? () {
                                context
                                    .read<AddressUpdateBloc>()
                                    .add(const AddresssInfoSubmitted());
                              }
                            : null,
                        child: utext(
                            title: "Update",
                            textAlign: TextAlign.center,
                            align: Alignment.center,
                            fontWeight: FontWeight.w500,
                            color: !state.isValid
                                ? AppTheme.yesArrow
                                : AppTheme.mainbg))));
      },
    );
  }
}
