
import 'package:flutter/material.dart';

Future<void> main() async {

  AppInstance instance = AppInstance();
  await instance.init();

  runApp(App(instance: instance));
}
