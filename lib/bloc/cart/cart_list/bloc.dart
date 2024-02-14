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

import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cazuapp/models/address.dart';
import 'package:cazuapp/models/cart_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/defaults.dart';
import '../../../components/dual.dart';
import '../../../core/protocol.dart';
import '../../../models/pre_order.dart';
import '../../../models/product.dart';
import '../../../models/variant.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CartListBloc extends Bloc<CartListEvent, CartListState> {
  final AppInstance instance;

  CartListBloc({required this.instance}) : super(const CartListState()) {
    on<CartListFetch>(_onCartFetch,
        transformer: throttleDroppable(throttleDuration));
    on<CartListReset>(_onCartListReset);
    on<CartListAdd>(_onCartAdd);
    on<ResetCounter>(_onResetCounter);
    on<CartListPre>(_onCartPre);
    on<CartFinish>(_onFinish);
    on<QuietReset>(_onQuietReset);

    on<CartListDelete>(_onCartListDelete);
    on<CartOp>(_onCartOp);
    on<UpdateOp>(_onUpdateOp);
    on<ResetQty>(_onResetQty);
    on<CartGetHolds>(_onCartGetHolds);
    on<EmptyCart>(_onEmptyCart);
    on<SetPrice>(_onSetPrice);

    on<SetAddress>(_onSetAddress);
    on<CartAddressReload>(_onAddressReload);
  }

  Future<void> _onUpdateOp(UpdateOp event, Emitter<CartListState> emit) async {
    final bool op = event.op;
    final CartItem item2 = event.item;

    if (op == true) {
      if (item2.qty >= 99) {
        return;
      }
      emit(state.copyWith(status: CartListStatus.reload));

      state.items[state.items.indexWhere((element) => item2 == element)] =
          item2.copyWith(qty: item2.qty + 1);

      instance.cart.items = state.items;
      return (emit(state.copyWith(items: state.items)));
    }

    if (op == false) {
      if (item2.qty <= 1) {
        return;
      }
      emit(state.copyWith(status: CartListStatus.reload));

      state.items[state.items.indexWhere((element) => item2 == element)] =
          item2.copyWith(qty: item2.qty - 1);

      instance.cart.items = state.items;
      return (emit(state.copyWith(items: state.items)));
    }
  }

  Future<void> _onSetPrice(SetPrice event, Emitter<CartListState> emit) async {}

  Future<void> _onFinish(CartFinish event, Emitter<CartListState> emit) async {
    emit(state.copyWith(status: CartListStatus.success));
  }

  Future<void> _onAddressReload(
      CartAddressReload event, Emitter<CartListState> emit) async {
    final int id = event.id;

    if (id != state.address) {
      return;
    }

    DualResult? result2 = await instance.address.info(id: id);

    if (result2?.status == Protocol.ok) {
      emit(state.copyWith(addressInfo: result2?.model));
    } else {
      emit(state.copyWith(addressInfo: null, address: 0));
    }
  }

  Future<void> _onResetCounter(
      ResetCounter event, Emitter<CartListState> emit) async {
    emit(state.copyWith(counter: 0));
  }

  Future<void> _onSetAddress(
      SetAddress event, Emitter<CartListState> emit) async {
    final address = event.address;

    DualResult? result2 = await instance.address.info(id: address);

    if (result2?.status == Protocol.ok) {
      emit(state.copyWith(address: address, addressInfo: result2?.model));
    } else {
      emit(state.copyWith(addressInfo: null, address: 0));
    }
  }

  Future<void> _onEmptyCart(
      EmptyCart event, Emitter<CartListState> emit) async {
    emit(const CartListState());
    await instance.cart.reset();
    emit(state.copyWith(status: CartListStatus.success));
  }

  Future<void> _onQuietReset(
      QuietReset event, Emitter<CartListState> emit) async {
    emit(state.copyWith(
        status: CartListStatus.success,
        items: const <CartItem>[],
        hasReachedMax: false));

    await instance.cart.reset();
  }

  Future<void> _onCartGetHolds(
      CartGetHolds event, Emitter<CartListState> emit) async {
    await instance.auth.getholds();

    if (instance.auth.ableToOrder != true) {
      emit(const CartListState());

      await instance.cart.reset();
    }
  }

  Future<void> _onResetQty(ResetQty event, Emitter<CartListState> emit) async {
    emit(state.copyWith(qty: 0));
  }

  Future<void> _onCartPre(
      CartListPre event, Emitter<CartListState> emit) async {
    if (instance.cart.items.isEmpty) {
      return;
    }

    DualResult? result = await instance.cart.preorder(items: state.items);

    if (result?.status == Protocol.ok) {
      emit(state.copyWith(preorder: result?.model));
      if (state.address == 0) {
        int? defaultAddress = await instance.address.getDefault();

        if (defaultAddress == 0) {
          emit(state.copyWith(addressInfo: null, address: 0));
        } else {
          DualResult? result2 =
              await instance.address.info(id: defaultAddress!);

          if (result2?.status == Protocol.ok) {
            emit(state.copyWith(
                addressInfo: result2?.model, address: defaultAddress));
          } else {
            emit(state.copyWith(
                addressInfo: null, address: 0, status: CartListStatus.failure));
          }
        }
      }

      emit(state.copyWith(
          preorder: result?.model, status: CartListStatus.success));
    }
  }

  Future<void> _onCartListDelete(
    CartListDelete event,
    Emitter<CartListState> emit,
  ) async {
    CartItem item = event.item;
    emit(state.copyWith(status: CartListStatus.reload));

    await instance.cart.delete(id: item);
  }

  Future<void> _onCartAdd(
      CartListAdd event, Emitter<CartListState> emit) async {
    Product product = event.product;
    Variant variant = event.variant;

    CartItem adding =
        CartItem(base: product, item: variant, qty: state.counter);

    log("Adding item: ${product.name} - qty: ${adding.qty}");

    int result = await instance.cart.add(item: adding);

    if (result == Protocol.ok) {
      log("Item ${product.name} added!");
    }
  }

  Future<void> _onCartListReset(
    CartListReset event,
    Emitter<CartListState> emit,
  ) async {
    emit(state.copyWith(status: CartListStatus.reload));

    final int address = state.address;
    final Address addressInfo = state.addressInfo;
    final int payment = state.payment;
    final int counter = state.counter;

    emit(const CartListState());
    emit(state.copyWith(
        status: CartListStatus.success,
        counter: counter,
        address: address,
        payment: payment,
        addressInfo: addressInfo));
  }

  Future<void> _onCartFetch(
    CartListFetch event,
    Emitter<CartListState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == CartListStatus.initial) {
        final posts = await _fetchItems();
        return emit(
          state.copyWith(
            status: CartListStatus.success,
            items: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await _fetchItems(state.items.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: CartListStatus.success,
                items: List.of(state.items)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: CartListStatus.failure));
    }
  }

  Future<List<CartItem>> _fetchItems([int startIndex = 0]) async {
    List<CartItem> items =
        await instance.cart.get(offset: startIndex, limit: _postLimit);

    if (items.isEmpty) {
      return List<CartItem>.empty();
    }

    return items;
  }

  Future<void> _onCartOp(CartOp event, Emitter<CartListState> emit) async {
    final bool op = event.op;

    if (op == true) {
      if (state.counter >= 99) {
        return;
      }
      return emit(state.copyWith(counter: state.counter + 1));
    }

    if (state.counter <= 0) {
      return;
    }

    return emit(state.copyWith(counter: state.counter - 1));
  }
}
