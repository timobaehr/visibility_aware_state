import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'start_screen.dart';
import 'screen_2.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'VisibilityAwareState Example',
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return StartScreen();
        },
      ),
      GoRoute(
        path: '/page2',
        builder: (BuildContext context, GoRouterState state) {
          return Screen2();
        },
      ),
    ],
  );
}