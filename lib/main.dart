import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database.dart';
import 'data/repositories/match_repository.dart';
import 'data/repositories/player_repository.dart';

/// Startpunt van de app.
///
/// Volgorde:
/// 1. Flutter-engine initialiseren
/// 2. Portrait-only afdwingen (geen rotatie naar landscape)
/// 3. Database openen
/// 4. Riverpod-providers overschrijven met echte implementaties
/// 5. App starten
Future<void> main() async {
  // Stap 1: zorg dat Flutter klaar is voor async werk vóór runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Stap 2: vergrendel op portretmodus
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Stap 3: open de database
  final db = await openAppDatabase();

  // Stap 4 + 5: start de app met de juiste providers
  runApp(
    ProviderScope(
      overrides: [
        // Geef de echte database-implementaties aan de providers
        playerRepositoryProvider.overrideWithValue(PlayerRepository(db)),
        matchRepositoryProvider.overrideWithValue(MatchRepository(db)),
      ],
      child: const ScoreApp(),
    ),
  );
}
