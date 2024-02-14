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

import '../../../core/theme.dart';
import '../../models/product.dart';

class FavoriteCollectionListItem extends StatelessWidget {
  const FavoriteCollectionListItem({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.only(right: 3.0),
        decoration: BoxDecoration(
          color: AppTheme.mainbg,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0)),
                  image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.fitHeight,
                      onError: (error, stackTrace) =>
                          const AssetImage('assets/null.png'))),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: InkResponse(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppTheme.rightarrow,
                              size: 17,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  //Text("\$${product.price.toString()}"),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
