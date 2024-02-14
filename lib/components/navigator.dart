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

import 'dart:async';

import 'package:flutter/material.dart';

/* Function to navigate to a specified page with a slide transition */
Future<dynamic> navigate(BuildContext context, Widget destinationPage,
    {bool root = true}) {
  /* Move focus to the next focusable widget */
  FocusScope.of(context).nextFocus();

  /* Create a Completer to handle the future result */
  Completer<void> completer = Completer<void>();

  /* Push a custom page route with a slide transition */
  Navigator.of(context, rootNavigator: root)
      .push(
    PageRouteBuilder(
      /* Build the destination page */
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      /* Define the slide transition animation */
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); /* Slide in from the right */
        const end = Offset.zero; /* Slide to the center */
        const curve = Curves.linear; /* Linear animation curve */
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        /* Apply the slide transition to the child widget */
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  )
      .then((result) {
    /* Complete the future with a null result */
    completer.complete(result);

    /* Handle the result here or perform additional actions if needed */
  });

  /* Return the Future for external use */
  return completer.future;
}
