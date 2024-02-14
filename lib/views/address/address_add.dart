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

import 'package:cazuapp/bloc/address/address_add/state.dart';
import 'package:cazuapp/bloc/cart/cart_list/bloc.dart';
import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/address/address_add/bloc.dart';
import '../../../components/alerts.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import 'address_list.dart';

class AddressAddPage extends StatelessWidget {
  const AddressAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressAddBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(const AddressAddEventOK()),
      child: const AddressDataForm(),
    );
  }
}

class AddressDataForm extends StatelessWidget {
  const AddressDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AddressAddBloc, AddressAddState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            BlocProvider.of<AddressAddBloc>(context)
                .add(AddressAddProgress(address: state.model));

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(buildAlert(state.errmsg));
          } else if (state.status.isSuccess) {
            BlocProvider.of<AddressAddBloc>(context)
                .add(const AddressAddEventOK());

            Navigator.of(context).canPop() ? Navigator.pop(context) : null;
            navigate(context, const AddressListPage());
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.background,
            appBar: const TopBar(title: "Add Address"),
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.10),
                                child: utext(
                                    fontSize: 14,
                                    title: "",
                                    color: AppTheme.title,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 6),
                          const Expanded(
                              flex: 0,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Expanded(
                                      flex: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          BuildName(),
                                          SizedBox(height: 16),
                                          BuildAddress(),
                                          SizedBox(height: 16),
                                          BuildZip(),
                                          SizedBox(height: 16),
                                          BuildCity(),
                                          SizedBox(height: 16),
                                          BuildCommentary(),
                                          SizedBox(height: 16),
                                          BuildOptions(),
                                          SizedBox(height: 16),
                                          AddButton(),
                                        ],
                                      ),
                                    ),
                                  ])),
                        ])))))));
  }
}

class BuildOptions extends StatelessWidget {
  const BuildOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) =>
          previous.model.options != current.model.options,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.adjust_outlined,
                        color: AppTheme.yesArrow, size: 17),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (options) => context
                            .read<AddressAddBloc>()
                            .add(AddressOptionsChanged(options)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Options',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class BuildCommentary extends StatelessWidget {
  const BuildCommentary({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) =>
          previous.model.commentary != current.model.commentary,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.comment_bank_rounded,
                        color: AppTheme.rightarrow, size: 17),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (commentary) => context
                            .read<AddressAddBloc>()
                            .add(AddressCommentaryChanged(commentary)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Commentary',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class BuildAddress extends StatelessWidget {
  const BuildAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) =>
          previous.model.address != current.model.address,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(FontAwesomeIcons.locationArrow,
                        color: AppTheme.rightarrow),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (address) => context
                            .read<AddressAddBloc>()
                            .add(AddressAddressChanged(address)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Address',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class BuildZip extends StatelessWidget {
  const BuildZip({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) => previous.model.zip != current.model.zip,
      builder: (context, state) {
        return Container(
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.numbers_outlined,
                        color: AppTheme.rightarrow, size: 17),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (zip) => context
                            .read<AddressAddBloc>()
                            .add(AddressZipChanged(zip)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Zip',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class BuildCity extends StatelessWidget {
  const BuildCity({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) =>
          previous.model.city != current.model.city,
      builder: (context, state) {
        return Container(
          height: size.height / 14,
          width: size.width / 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppTheme.forminput,
              border: Border.all(color: AppTheme.darkset)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.location_city_outlined,
                        color: AppTheme.rightarrow, size: 17),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (city) => context
                            .read<AddressAddBloc>()
                            .add(AddressCityChanged(city)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'City',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class BuildName extends StatelessWidget {
  const BuildName({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
      buildWhen: (previous, current) =>
          previous.model.name != current.model.name,
      builder: (context, state) {
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
                    const Icon(Icons.location_history_outlined,
                        color: AppTheme.rightarrow, size: 17),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        key: const Key('SignupForm_firstInput_textField'),
                        onChanged: (name) => context
                            .read<AddressAddBloc>()
                            .add(AddressNameChanged(name)),
                        maxLines: 1,
                        cursorColor: Colors.black87,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.ubuntu(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AddressAddBloc, AddressAddState>(
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
                                    .read<AddressAddBloc>()
                                    .add(const AddressAddSubmitted());
                                context.read<CartListBloc>().add(CartListPre());
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            : null,
                        child: utext(
                            title: "Add address",
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
