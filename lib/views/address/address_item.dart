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

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/models/address.dart';
import 'package:cazuapp/views/address/address_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../components/utext.dart';
import '../../../core/theme.dart';

class AddressListItem extends StatelessWidget {
  const AddressListItem({required this.address, this.pick = false, super.key});

  final Address address;
  final bool pick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {
              if (pick)
                {
                  Navigator.pop(
                      context, DualResult(status: 1, model: address.id)),
                }
              else
                {navigate(context, AddressDataPage(id: address.id))}
            },
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
                  horizontal: ScreenUtil().screenWidth * 0.05,
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
                height: ScreenUtil().scaleHeight * 165,
                child: InkWell(
                    child: Column(children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(height: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.chevronRight,
                          color: AppTheme.primarycolor, size: 18),
                      const SizedBox(width: 5),
                      utext(
                          title: address.name.value,
                          fontWeight: FontWeight.w500,
                          resize: true),
                    ]),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(height: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.locationCrosshairs,
                          color: AppTheme.primarycolor, size: 18),
                      const SizedBox(width: 5),
                      utext(
                          title: address.address.value,
                          fontWeight: FontWeight.w500,
                          resize: true),
                    ]),
                  ]),
                  Column(children: <Widget>[
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.locationDot,
                          color: AppTheme.focuschill2, size: 18),
                      const SizedBox(width: 5),
                      utext(
                          title: "${address.city.value}, ${address.zip.value}",
                          fontWeight: FontWeight.w500,
                          resize: true),
                    ]),
                  ]),
                  const SizedBox(height: 15),
                  const Divider(),
                  Column(children: <Widget>[
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Icon(FontAwesomeIcons.calendar,
                          color: AppTheme.orange, size: 18),
                      const SizedBox(width: 5),
                      utext(title: Etc.prettySmalldate(address.createdat))
                    ]),
                  ]),
                ])))));
  }
}
