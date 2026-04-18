import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

import '../models/player.dart';

/// Beheert alle spelers in de database.
///
/// Repository-pattern: de rest van de app weet niet hoe data opgeslagen wordt.
/// Later kunnen we deze klasse vervangen door een cloud-versie zonder de UI aan te raken.
class PlayerRepository {
  static const _storeName = 'players';
  final _store = stringMapStoreFactory.store(_storeName);
  final Database _db;

  PlayerRepository(this._db);

  /// Geeft een live stream van alle spelers (sorteer op aanmaakdatum).
  /// Elke keer als er iets verandert, stuurt de stream een nieuwe lijst.
  Stream<List<Player>> watchAll() {
    return _store
        .query(finder: Finder(sortOrders: [SortOrder('createdAt')]))
        .onSnapshots(_db)
        .map(
          (snapshots) => snapshots
              .map(
                (s) => Player.fromJson(Map<String, dynamic>.from(s.value)),
              )
              .toList(),
        );
  }

  Future<List<Player>> getAll() async {
    final snapshots = await _store.find(
      _db,
      finder: Finder(sortOrders: [SortOrder('createdAt')]),
    );
    return snapshots
        .map((s) => Player.fromJson(Map<String, dynamic>.from(s.value)))
        .toList();
  }

  Future<Player?> getById(String id) async {
    final record = await _store.record(id).get(_db);
    if (record == null) return null;
    return Player.fromJson(Map<String, dynamic>.from(record));
  }

  Future<void> save(Player player) async {
    await _store.record(player.id).put(_db, player.toJson());
  }

  Future<void> delete(String id) async {
    await _store.record(id).delete(_db);
  }
}

// ── Riverpod providers ────────────────────────────────────────────────────────

/// Wordt overschreven in main.dart nadat de database klaar is.
final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => throw UnimplementedError('Override playerRepositoryProvider in main'),
);

/// Live stream van alle spelers. Gebruik dit in de UI.
final playersProvider = StreamProvider<List<Player>>(
  (ref) => ref.watch(playerRepositoryProvider).watchAll(),
);
