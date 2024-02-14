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

import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../views/address/address_add.dart';

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: 120,
        child: ElevatedButton.icon(
          icon: const Icon(
            FontAwesomeIcons.locationDot,
            color: AppTheme.white,
            size: 19.0,
          ),
          label: utext(
              title: "New",
              fontSize: 16,
              color: AppTheme.white,
              align: Alignment.center,
              fontWeight: FontWeight.w500),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            elevation: 3.0,
            backgroundColor: AppTheme.iconcolors,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          key: const Key('AddAddressForm_continue_raisedButton'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const AddressAddPage()));
          },
        ));
  }
}
