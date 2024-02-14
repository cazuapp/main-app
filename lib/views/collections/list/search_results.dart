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

import 'package:cazuapp/bloc/collections/list/home_search/bloc.dart';
import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/views/collections/list/final_search.dart';
import 'package:cazuapp/views/collections/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.id, required this.name});

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ProductCollectionSearchBloc(
                instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetID(id: id, name: name))
              ..add(SearchReset()))
      ],
      child: const SearchList(),
    );
  }
}

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProductCollectionSearchBloc,
        ProductCollectionSearchState>(builder: (context, state) {
      switch (state.status) {
        case ProductSearchStatus.initial:
          return const Loader();

        case ProductSearchStatus.loading:
          return const Loader();
        case ProductSearchStatus.failure:
          return const FailurePage(
              title: "Collection list", subtitle: "Error loading collections");
        case ProductSearchStatus.success:
          return Scaffold(
              appBar: null,
              backgroundColor: AppTheme.white,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor:
                        Colors.transparent, // transparent status bar
                    statusBarIconBrightness:
                        Brightness.dark, // status bar icons' color
                  ),
                  child: SafeArea(
                      child: SizedBox(
                          height: size.height,
                          child: Column(children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    /* Search button widget */
                                    child: const FinalSearchBar())),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * 0.00,
                                    bottom: size.height * 0.02,
                                    left: size.width * 0.04,
                                    right: size.width * 0.04),
                                child: state.text.isNotEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                            const SizedBox(height: 10),
                                            utext(
                                                title:
                                                    "Results for ${state.text}",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                            utext(
                                                title:
                                                    "${state.total.toString()} in total",
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16)
                                          ])
                                    : const SizedBox.shrink()),
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
                                                  product:
                                                      state.products[index]),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax
                                          ? state.products.length
                                          : state.products.length + 1,
                                      controller: _scrollController,
                                    )))
                          ])))));
      }
    });
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
      context.read<ProductCollectionSearchBloc>().add(OnScroll());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
