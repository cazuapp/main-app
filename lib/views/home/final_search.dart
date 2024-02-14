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

import 'package:cazuapp/bloc/home/home_search/bloc.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalSearchBar extends StatefulWidget {
  const FinalSearchBar({super.key});

  @override
  State<FinalSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<FinalSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    );

    _textController.addListener(() {
      if (_textController.text.isNotEmpty) {
        _animationController.value = 1.0; // Immediate appearance
      } else {
        _animationController.reverse(); // Animated disappearance
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSearchBloc, HomeSearchState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _backButton(context),
            const SizedBox(width: 20),
            Expanded(child: _searchBar()),
          ],
        );
      },
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        FontAwesomeIcons.arrowLeft,
        size: 25,
        color: AppTheme.darkgray,
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 14.w),
        child: _searchInputField(),
      ),
    );
  }

  Widget _searchInputField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.search, color: Colors.black),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            controller: _textController,
            onChanged: (text) => _handleSearchTextChange(context, text),
            maxLines: 1,
            cursorColor: Colors.black,
            style: GoogleFonts.ubuntu(
              fontSize: 14.sp,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '',
              suffixIcon: _clearButton(),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _clearButton() {
    return FadeTransition(
      opacity: _curvedAnimation,
      child: IconButton(
        icon: const Icon(FontAwesomeIcons.xmark, size: 25),
        color: Colors.black54,
        onPressed: () {
          _textController.clear();
          BlocProvider.of<HomeSearchBloc>(context).add(SearchReset());
        },
      ),
    );
  }

  void _handleSearchTextChange(BuildContext context, String text) {
    BlocProvider.of<HomeSearchBloc>(context).add(SearchReset());
    if (text.isNotEmpty) {
      BlocProvider.of<HomeSearchBloc>(context).add(SearchRequest(text: text));
    }
  }
}
