import 'package:flutter/material.dart';
import 'package:kcards/router.dart';
import 'package:kcards/theme.dart';

class KCardsApp extends StatelessWidget {
  const KCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KCards',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
