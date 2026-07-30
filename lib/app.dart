import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/core/theme/app_theme.dart';
import 'package:kakeibo/features/settings/presentation/providers/settings_provider.dart';
import 'package:kakeibo/router/app_router.dart';

class KakeiboApp extends ConsumerWidget {
  const KakeiboApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Kakeibo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
