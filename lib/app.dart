import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/home_shell.dart';

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoply',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}

class ShoplyRoot extends StatelessWidget {
  const ShoplyRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: ShoplyApp());
  }
}
