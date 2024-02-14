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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final dynamic fawesome;
  final Color color;

  const FavButton(
      {super.key,
      this.fawesome,
      required this.name,
      required this.onTap,
      this.color = AppTheme.black});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(right: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(2, 2),
                blurRadius: 1,
              ),
            ],
          ),
          width: ScreenUtil().scaleWidth * 100,
          height: ScreenUtil().scaleHeight * 90,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(fawesome, color: color),
                const SizedBox(height: 9),
                utext(
                    title: name,
                    color: AppTheme.black,
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    fontWeight: FontWeight.w400,
                    shrink: true,
                    fontSize: 16),
              ]),
        ));
  }
}
