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

import 'package:cazuapp/bloc/user/app_info/bloc.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/views/menu.dart';
import 'package:cazuapp/views/status/error_page.dart';
import 'package:cazuapp/views/status/maintaince.dart';
import 'package:cazuapp/views/status/nointernet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cazuapp/bloc/user/auth/bloc.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:cazuapp/views/auth/banned.dart';
import 'package:cazuapp/views/auth/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/cart/cart_list/bloc.dart';
import 'bloc/user/auth/repository.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  /* Limits orientation to default portrait */

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /* Initializses AppInstance (core class) */

  AppInstance instance = AppInstance();
  await dotenv.load(fileName: ".env");

  if (await instance.pingServer() == true) {
    await instance.init();
  }

  runApp(App(instance: instance));
}

class App extends StatelessWidget {
  final AppInstance instance;

  const App({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(instance: instance)),
        BlocProvider(create: (_) => CartListBloc(instance: instance)),
        BlocProvider(create: (_) => AppInfoBloc(instance: instance)),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initialization();
  }

/*  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //context.read<AppInfoBloc>().add(StatusChange(state));
  }
*/
  void initialization() async {
    log("Running splash ..");
    // await Future.delayed(const Duration(seconds: 0));

    FlutterNativeSplash.remove();
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return GestureDetector(
        onTapDown: (details) {
          //   context.read<AppInfoBloc>().add(TapChange(value: tapAction.tapDown, location: details.globalPosition));
        },
        onDoubleTapDown: (details) {
          //  context.read<AppInfoBloc>().add(TapChange(value: tapAction.doubleTapDown, location: details.globalPosition));
        },
        onDoubleTapCancel: () {
          // context.read<AppInfoBloc>().add(const TapChange(value: tapAction.doubleTapCancel));
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        MenuPage.route(), (route) => false);
                    break;

                  case AuthenticationStatus.nointernet:
                    _navigator.pushAndRemoveUntil<void>(
                      NoInternetPage.route(),
                      (route) => false,
                    );
                    break;

                  case AuthenticationStatus.maint:
                    _navigator.pushAndRemoveUntil<void>(
                        MaintaincePage.route(), (route) => false);
                    break;

                  case AuthenticationStatus.error:
                    _navigator.pushAndRemoveUntil<void>(
                        ErrorPage.route(), (route) => false);
                    break;

                  case AuthenticationStatus.banned:
                    _navigator.pushAndRemoveUntil<void>(
                        BannedPage.route(), (route) => false);
                    break;

                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(),
                      (route) => false,
                    );
                    break;

                  case AuthenticationStatus.unknown:
                    break;
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => Loader.route(),
        ));
  }
}
