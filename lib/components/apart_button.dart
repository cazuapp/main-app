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

import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../views/favorites/favorites_list.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});
  @override
  State<FavoriteButton> createState() => _FavState();
}

class _FavState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: ScreenUtil().scaleHeight * 40,
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
              minimumSize: Size.fromHeight(ScreenUtil().scaleHeight * 50),
              elevation: 0,
              backgroundColor: AppTheme.fav,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            key: const Key('signupForm_continue_raisedButton'),
            onPressed: () {
              navigate(context, const FavoritesPage());
            },
            child: Center(
              child: utext(
                title: "Favorites",
                textAlign: TextAlign.center,
                align: Alignment.center,
                fontWeight: FontWeight.w500,
                color: AppTheme.mainbg,
              ),
            ),
          ),
        ));
  }
}
