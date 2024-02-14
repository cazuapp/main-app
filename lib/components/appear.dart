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

/* Function to navigate to a specified page with a top-to-bottom appear effect from the position of the search bar */
Future<void> appear(BuildContext context, Widget destinationPage,
    {bool root = true}) {
  // Create a Completer to handle the future result
  Completer<void> completer = Completer<void>();

  // Push a custom page route with a top-to-bottom slide transition
  Navigator.of(context, rootNavigator: root)
      .push(
    PageRouteBuilder(
      // Build the destination page
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,

      // Define the transition animation with a suitable duration for the effect
      transitionDuration:
          const Duration(milliseconds: 0), // Adjust duration to control speed
      reverseTransitionDuration: const Duration(milliseconds: 0),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the slide transition animation
        var slideAnimation = Tween(
          begin: const Offset(0.0, -1.0), // Start from above the screen
          end: Offset.zero, // End at the center (no offset)
        ).animate(animation);

        // Apply the slide transition to the child widget
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    ),
  )
      .then((result) {
    // Complete the future with a null result
    completer.complete(result);
  });

  // Return the Future for external use
  return completer.future;
}
