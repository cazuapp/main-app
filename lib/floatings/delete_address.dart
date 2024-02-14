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

import '../core/theme.dart';

class DeleteAddress extends StatelessWidget {
  final int id;

  const DeleteAddress({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        elevation: 1.2,
        onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) =>  DeleteAddressConfirmPage(id: id)));
        },
        label: const Text('Delete address'),
        icon: const Icon(Icons.add_box),
        backgroundColor: AppTheme.iconsSettings);
  }
}
