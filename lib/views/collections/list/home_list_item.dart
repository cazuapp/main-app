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

import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/models/product_list.dart';
import 'package:cazuapp/views/products/product_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/* Displayer of home items */

class HomeListItem extends StatelessWidget {
  final ProductListItem product;
  final int index;
  final int length;

  const HomeListItem(
      {super.key,
      required this.product,
      required this.index,
      required this.length});

  @override
  Widget build(BuildContext context) {
    Color displayclr = AppTheme.black; // Adjust color based on your theme
    return InkWell(
      onTap: () => navigate(context, ProductDetailPage(id: product.id)),
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().scaleHeight * 1,
          bottom: ScreenUtil().scaleHeight * 5,
          left: ScreenUtil().scaleWidth * 15,
          right: ScreenUtil().scaleWidth * 15,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().scaleHeight * 10,
                bottom: ScreenUtil().scaleHeight * 14,
                left: ScreenUtil().screenWidth * 0.02,
                right: ScreenUtil().screenWidth * 0.02,
              ),
              color: AppTheme.mainbg,
              height: ScreenUtil().scaleHeight * 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.network(
                      product.image,
                      height: 150.h,
                      width: 110.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/null.png'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        utext(
                          title: product.name,
                          color: displayclr,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: <Widget>[
                            utext(
                              title: "\$${product.price.toString()}",
                              fontWeight: FontWeight.w500,
                              resize: true,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product.description,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                color: AppTheme.darkgray,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (index != length - 1)
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().scaleHeight * 5,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.settings,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
