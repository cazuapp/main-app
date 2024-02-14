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

import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/models/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductListItemDisplay extends StatelessWidget {
  final ProductListItem product;
  final bool pick;
  final bool search;

  const ProductListItemDisplay(
      {super.key,
      required this.product,
      this.pick = false,
      this.search = false});

  @override
  Widget build(BuildContext context) {
    //var id = product.id.toString();
    var display = product.name;
    Color displayclr = AppTheme.black; // Adjust color based on your theme

    return InkWell(
      onTap: () => {},
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().scaleHeight * 5,
          bottom: ScreenUtil().scaleHeight * 20,
          left: ScreenUtil().scaleWidth * 17,
          right: ScreenUtil().scaleWidth * 17,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().scaleHeight * 10,
            horizontal: ScreenUtil().screenWidth * 0.02,
          ),
          decoration: BoxDecoration(
            color: AppTheme.mainbg,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: ScreenUtil().scaleHeight * 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(2.w),
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().scaleHeight * 10),
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme
                            .darkset, // Change this to your desired border color
                        width: 1.0, // Adjust border width as needed
                        style: BorderStyle
                            .solid, // You can change this to dotted, dashed, etc.
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2.0)
                      ],
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) =>
                            const AssetImage('assets/null.png'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    utext(
                        title: display,
                        color: displayclr,
                        fontWeight: FontWeight.w500,
                        resize: true),
                    const Divider(),
                    Row(
                      children: <Widget>[
                        const Icon(FontAwesomeIcons.noteSticky,
                            color: AppTheme.black, size: 18),
                        SizedBox(width: 5.w),
                        utext(
                            title: product.description,
                            fontWeight: FontWeight.w500,
                            resize: true,
                            shrink: true),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(FontAwesomeIcons.dollarSign,
                            color: AppTheme.lockeye2, size: 18),
                        SizedBox(width: 5.w),
                        utext(
                            title: product.price.toString(),
                            fontWeight: FontWeight.w500,
                            resize: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
