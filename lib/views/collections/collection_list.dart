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
import 'package:cazuapp/views/collections/collection_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/notfound.dart';
import '../../../core/theme.dart';
import '../../bloc/collections/collections/bloc.dart';
import '../../components/apart_button.dart';
import '../../components/utext.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionBloc(
          instance: BlocProvider.of<AuthenticationBloc>(context).instance)
        ..add(CollectionsFetched()),
      child: const CollectionList(),
    );
  }
}

class CollectionList extends StatefulWidget {
  const CollectionList({super.key});
  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _description() {
    return BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              utext(
                  title: "All categories",
                  color: AppTheme.main,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              const SizedBox(height: 2),
              utext(title: "${state.total} in total", color: AppTheme.darkgray),
            ],
          ));
    });
  }

  Widget _favorites() {
    return BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
      return const Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12),
              FavoriteButton(),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = "Browse";
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        switch (state.status) {
          case CollectionStatus.loading:
            return const Loader();
          case CollectionStatus.initial:
            return const SizedBox.shrink();
          case CollectionStatus.failure:
            return FailurePage(
                title: title, subtitle: "Failed to retrieve collection list.");
          case CollectionStatus.success:
            if (state.collections.isEmpty) {
              return NotFoundPage(
                  title: title, main: "You have not added any collections.");
            }
            return Scaffold(
              backgroundColor: AppTheme.mainbg,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                            vertical: size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _description(),
                            _favorites(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          thickness: 7,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 1.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  index >= state.collections.length
                                      ? const SizedBox.shrink()
                                      : CollectionListItem(
                                          collection: state.collections[index]),
                                ],
                              );
                            },
                            itemCount: state.hasReachedMax
                                ? state.collections.length
                                : state.collections.length + 1,
                            controller: _scrollController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
    if (_isBottom) context.read<CollectionBloc>().add(CollectionsFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
