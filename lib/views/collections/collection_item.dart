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
import 'package:cazuapp/views/collections/list/home.dart';
import 'package:flutter/material.dart';

import '../../components/utext.dart';
import '../../core/theme.dart';
import '../../models/collection.dart';

class CollectionListItem extends StatelessWidget {
  const CollectionListItem({required this.collection, super.key});
  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: InkResponse(
        onTap: () => navigateToProductCollection(context),
        child: Material(
          elevation: 5.0, // Added elevation for shadow
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: buildCollectionContainer(),
        ),
      ),
    );
  }

  void navigateToProductCollection(BuildContext context) {
    navigate(context,
        ProductCollectionPage(name: collection.title, id: collection.id));
  }

  Widget buildCollectionContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildImageSection(),
          buildTitleSection(),
        ],
      ),
    );
  }

  Widget buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: SizedBox(
        height: 100.0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[buildNetworkImage()],
          ),
        ),
      ),
    );
  }

  Widget buildNetworkImage() {
    return Expanded(
      child: Image.network(
        collection.imagesrc,
        width: 400,
        height: 600,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/null.png'),
      ),
    );
  }

  Widget buildTitleSection() {
    return Container(
      color: AppTheme.mainbg,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15.0),
          utext(
            title: collection.title,
            fontSize: 17,
            color: AppTheme.darkgray,
            align: Alignment.center,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
