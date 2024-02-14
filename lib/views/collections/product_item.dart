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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/utext.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../products/product_details.dart';

class ProductCollectionListItem extends StatelessWidget {
  const ProductCollectionListItem({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigate(context, ProductDetailPage(id: product.id)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: _buildProductContainer(),
      ),
    );
  }

  Widget _buildProductContainer() {
    return Container(
      decoration: _boxDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align items to the start of the cross axis
          children: <Widget>[
            _productImage(),
            Expanded(
              child: _productDetails(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: AppTheme.mainbg,
      border: Border.all(color: Colors.grey.shade300, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(1, 2),
          blurRadius: 1,
        ),
      ],
    );
  }

  Widget _productImage() {
    return Container(
      alignment: Alignment.center,
      height: 120.h,
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
        image: DecorationImage(
          image: NetworkImage(product.image),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _productDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use the minimum size of the column
        children: <Widget>[
          _styledText(product.name, AppTheme.black, FontWeight.w500),
          _styledText("\$${product.price}", AppTheme.black, FontWeight.w500),
          const SizedBox(height: 8.0), // Spacer
          _descriptionText(product.description),
        ],
      ),
    );
  }

  Widget _styledText(String text, Color color, FontWeight fontWeight) {
    return utext(
      title: text,
      color: color,
      fontWeight: fontWeight,
      align: Alignment.bottomLeft,
      textAlign: TextAlign.left,
    );
  }

  Widget _descriptionText(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: GoogleFonts.ubuntu(
        fontSize: ScreenUtil().scaleWidth * 13,
      ),
    );
  }
}
