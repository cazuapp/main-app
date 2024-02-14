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

import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/views/collections/list/home.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/collection.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {required this.index, required this.collection, super.key});
  final Collection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    double padd = 10.0;

    if (index == 0) {
      padd = 0.0;
    }

    return InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => ProductCollectionPage(
                  id: collection.id, name: collection.title)));
        },
        child: Padding(
            padding: EdgeInsets.only(left: padd),
            child: Container(
              width: 160,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 103.0,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Image.network(
                                collection.imagesrc,
                                width: 120,
                                height: 100,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/null.png');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        color: AppTheme.mainbg,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 8.0,
                            ),
                            utext(
                                title: collection.title,
                                fontSize: 16,
                                color: AppTheme.darkgray,
                                align: Alignment.center,
                                fontWeight: FontWeight.w600),
                            const SizedBox(
                              height: 0.0,
                            ),
                          ],
                        ))
                  ]),
            )));
  }
}
