/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
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
import 'package:flutter/material.dart';

class AppDivisor extends StatelessWidget {
  final double top;
  final double bottom;

  const AppDivisor({super.key, this.top = 20.0, this.bottom = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
            EdgeInsets.only(top: top, left: 5.0, right: 5.0, bottom: bottom),
        child: const Divider(
          color: AppTheme.darkset,
          height: 1,
          thickness: 1,
        ));
  }
}
