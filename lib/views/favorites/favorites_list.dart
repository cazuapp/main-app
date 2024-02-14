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

import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/topbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/favorites/favorite_list/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/notfound.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';
import '../../../floatings/home.dart';
import '../collections/product_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(FavoritesFetched()),
      child: const ProductCollectionList(),
    );
  }
}

class ProductCollectionList extends StatefulWidget {
  const ProductCollectionList({super.key});
  @override
  State<ProductCollectionList> createState() => _ProductCollectionListState();
}

class _ProductCollectionListState extends State<ProductCollectionList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _description() {
    return BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
      final size = MediaQuery.of(context).size;

      return Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.00,
              bottom: size.height * 0.00,
              left: size.width * 0.04,
              right: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              utext(
                  title: "Favorites",
                  color: AppTheme.main,
                  fontWeight: FontWeight.w600),
              const SizedBox(height: 2),
              utext(title: "${state.total} in total", color: AppTheme.darkgray),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = "Favorites";

    final size = MediaQuery.of(context).size;

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        switch (state.status) {
          case FavoriteStatus.loading:
            return const Loader();

          case FavoriteStatus.initial:
            return const SizedBox.shrink();
          case FavoriteStatus.failure:
            return FailurePage(
                title: title, subtitle: "Failed to retrieve favorite list.");

          case FavoriteStatus.success:
            if (state.products.isEmpty) {
              return NotFoundPage(
                  floating: const HomeFloating(),
                  title: title,
                  main: "You have not added any favorite.");
            }
            return Scaffold(
                backgroundColor: AppTheme.white,
                appBar: TopBar(title: title),
                body: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Column(
                        children: <Widget>[
                          _description(),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Scrollbar(
                                thumbVisibility: true,
                                controller: _scrollController,
                                thickness: 7,
                                child: ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(children: <Widget>[
                                      index >= state.products.length
                                          ? const SizedBox.shrink()
                                          : ProductCollectionListItem(
                                              product: state.products[index]),
                                    ]);
                                  },
                                  itemCount: state.hasReachedMax
                                      ? state.products.length
                                      : state.products.length + 1,
                                  controller: _scrollController,
                                )),
                          ),
                          const SizedBox(height: 23),
                        ],
                      )),
                ));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FavoriteBloc>().add(FavoritesFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
