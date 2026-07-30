import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo/app_shell.dart';
import 'package:kakeibo/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:kakeibo/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:kakeibo/features/settings/presentation/screens/settings_screen.dart';
import 'package:kakeibo/features/expenses/presentation/screens/day_expenses_screen.dart';
import 'package:kakeibo/features/categories/presentation/screens/manage_categories_screen.dart';
import 'package:kakeibo/features/splash/presentation/screens/splash_screen.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorCalendarKey = GlobalKey<NavigatorState>(debugLabel: 'calendar');
final _shellNavigatorStatsKey = GlobalKey<NavigatorState>(debugLabel: 'stats');
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(
            navigationShell: navigationShell,
            child: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCalendarKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const CalendarScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
                routes: [
                  GoRoute(
                    path: 'day/:date',
                    pageBuilder: (context, state) {
                      final dateStr = state.pathParameters['date']!;
                      final date = DateTime.parse(dateStr);
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: DayExpensesScreen(date: date),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeOutCubic;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(position: offsetAnimation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorStatsKey,
            routes: [
              GoRoute(
                path: '/statistics',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const StatisticsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/categories/manage',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ManageCategoriesScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    ],
  );
}
