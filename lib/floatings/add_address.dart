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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/theme.dart';
import '../components/utext.dart';
import '../views/address/address_add.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(21.0))),
        elevation: 1.2,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddressAddPage()));
        },
        label: utext(
            title: "Add",
            color: AppTheme.white,
            fontWeight: FontWeight.w500,
            fontSize: 16),
        icon: const Icon(FontAwesomeIcons.locationArrow),
        backgroundColor: AppTheme.iconsSettings);
  }
}
