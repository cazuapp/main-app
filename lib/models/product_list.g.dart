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

part of 'product_list.dart';

ProductListItem _$ProductListItemListFromJson(Map<String, dynamic> json) =>
    ProductListItem(
        id: json['id'] as int,
        collection: json['collection'] as int,
        price: json['price'] ?? 0.0,
        description: json['description'] as String,
        image: json['image'] != null
            ? Etc.makepublic(destination: json['image'])
            : Etc.makepublic(destination: "assets/images/etc/null.png"),
        name: json['name'] as String,
        created: json['createdat'] as String,
        collectionTitle: json['collection_title'] as String);
