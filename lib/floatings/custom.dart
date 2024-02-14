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
import '../components/utext.dart';

class CustomFloat extends StatelessWidget {
  final VoidCallback? onPressed;

  final String text;
  final dynamic icon;
  final Color iconColor;
  final Color? background;
  const CustomFloat(
      {super.key,
      this.onPressed,
      required this.icon,
      required this.iconColor,
      required this.text,
      this.background});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        elevation: 1.2,
        onPressed: () => onPressed!(),
        label: utext(
            title: text,
            color: iconColor,
            fontWeight: FontWeight.w500,
            fontSize: 15),
        icon: Icon(icon, size: 17, color: iconColor),
        backgroundColor: background ?? AppTheme.iconsSettings);
  }
}
