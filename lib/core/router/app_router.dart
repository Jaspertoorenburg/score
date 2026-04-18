import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/history/history_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/players/players_screen.dart';
import '../../features/yahtzee_play/yahtzee_play_screen.dart';
import '../../features/yahtzee_result/yahtzee_result_screen.dart';
import '../../features/yahtzee_setup/yahtzee_setup_screen.dart';

/// Alle routes van de app op één plek.
///
/// go_router vertaalt URL-paden naar schermen.
/// context.go('/players') navigeert naar het spelersscherm, etc.
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/players',
      builder: (context, state) => const PlayersScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/game/yahtzee/setup',
      builder: (context, state) => const YahtzeeSetupScreen(),
    ),
    GoRoute(
      path: '/game/yahtzee/play',
      builder: (context, state) => const YahtzeePlayScreen(),
    ),
    GoRoute(
      path: '/game/yahtzee/result',
      builder: (context, state) => const YahtzeeResultScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Pagina niet gevonden: ${state.uri}')),
  ),
);
