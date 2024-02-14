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

part of 'bloc.dart';

abstract class ProductInfoEvent extends Equatable {
  const ProductInfoEvent();
}

class ProductInfoEventOK extends ProductInfoEvent {
  const ProductInfoEventOK();

  @override
  List<Object> get props => [];
}

class ProductInfoRequest extends ProductInfoEvent {
  const ProductInfoRequest();

  @override
  List<Object> get props => [];
}

class ProductSetFavorite extends ProductInfoEvent {
  const ProductSetFavorite({required this.status});

  final bool status;

  @override
  List<Object> get props => [];
}

class ProductSetQuantity extends ProductInfoEvent {
  const ProductSetQuantity({required this.quantity});

  final int quantity;

  @override
  List<Object> get props => [quantity];
}

class ChangeInUse extends ProductInfoEvent {
  const ChangeInUse({required this.variant});

  final Variant variant;

  @override
  List<Object> get props => [variant];
}

class ChangeDisplay extends ProductInfoEvent {
  const ChangeDisplay({required this.image, required this.index});

  final String image;
  final int index;

  @override
  List<Object> get props => [image, index];
}
