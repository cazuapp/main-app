import 'package:cazuapp/models/collection.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';

// ignore: must_be_immutable
class ProfileBox extends StatelessWidget {
  Collection collection;

  ProfileBox({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double? setwidth = 0;

    if (size.width <= 320) {
      setwidth = 75;
    } else {
      setwidth = 90;
    }

    return Container(
      height: 40,
      width: setwidth,
      decoration: BoxDecoration(
        color: AppTheme.settings,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff131200).withOpacity(0.11),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* SizedBox(
          height: 20,
          width: 20,
          child: Icon(
            iconsrc,
            color: AppTheme.iconsSettings,
          ),
        ),*/
            const SizedBox(height: 9),
            Text(collection.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ]),
    );
  }
}
