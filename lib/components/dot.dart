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

class DotWidget extends StatelessWidget {
  final int activeIndex;
  final int dotIndex;

  const DotWidget(
      {super.key, required this.activeIndex, required this.dotIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color:
                (dotIndex == activeIndex) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle),
      ),
    );
  }
}
