import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

import '../models/game_match.dart';

/// Beheert alle gespeelde potjes in de database.
class MatchRepository {
  static const _storeName = 'matches';
  final _store = stringMapStoreFactory.store(_storeName);
  final Database _db;

  MatchRepository(this._db);

  /// Geeft een live stream van alle potjes, nieuwste eerst.
  Stream<List<GameMatch>> watchAll() {
    return _store
        .query(
          finder: Finder(sortOrders: [SortOrder('startedAt', false)]),
        )
        .onSnapshots(_db)
        .map(
          (snapshots) => snapshots
              .map(
                (s) =>
                    GameMatch.fromJson(Map<String, dynamic>.from(s.value)),
              )
              .toList(),
        );
  }

  Future<void> save(GameMatch match) async {
    await _store.record(match.id).put(_db, match.toJson());
  }

  Future<GameMatch?> getById(String id) async {
    final record = await _store.record(id).get(_db);
    if (record == null) return null;
    return GameMatch.fromJson(Map<String, dynamic>.from(record));
  }
}

// ── Riverpod providers ────────────────────────────────────────────────────────

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => throw UnimplementedError('Override matchRepositoryProvider in main'),
);

final matchesProvider = StreamProvider<List<GameMatch>>(
  (ref) => ref.watch(matchRepositoryProvider).watchAll(),
);
