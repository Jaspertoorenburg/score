import '../../data/models/player.dart';
import 'yahtzee_categories.dart';
import 'yahtzee_engine.dart';

/// De volledige toestand van een lopend Yahtzee-potje.
///
/// Onveranderlijk (immutable): elke actie produceert een nieuw object.
/// Dat maakt debuggen makkelijker en past perfect bij Riverpod.
class YahtzeeGameState {
  final String matchId;
  final List<Player> players;
  final int currentPlayerIndex;

  /// Huidige ronde: 1 t/m 13. Na ronde 13 is het spel klaar.
  final int round;

  /// Waarden van de 5 dobbelstenen (1–6). Begint als [0,0,0,0,0] (nog niet gegooid).
  final List<int> dice;

  /// Welke dobbelstenen worden bewaard voor de volgende worp.
  final List<bool> kept;

  /// Worpen die nog over zijn in deze beurt: 3 = nog niet begonnen, 0 = moet scoren.
  final int rollsRemaining;

  /// Scorekaarten per speler-ID. Waarde null = categorie nog niet ingevuld.
  final Map<String, Map<YahtzeeCategory, int>> scores;

  /// Aantal extra Yahtzees per speler (bonus = +100 per stuk).
  final Map<String, int> yahtzeeBonusCounts;

  final bool isFinished;

  const YahtzeeGameState({
    required this.matchId,
    required this.players,
    required this.currentPlayerIndex,
    required this.round,
    required this.dice,
    required this.kept,
    required this.rollsRemaining,
    required this.scores,
    required this.yahtzeeBonusCounts,
    this.isFinished = false,
  });

  // ── Handige getters ───────────────────────────────────────────────────────

  Player get currentPlayer => players[currentPlayerIndex];

  bool get hasRolled => rollsRemaining < 3;

  bool get canRoll => rollsRemaining > 0 && !isFinished;

  bool get mustScore => rollsRemaining == 0 && hasRolled;

  bool get diceAreReady => hasRolled;

  /// Geeft alle ingevulde categorieën voor de huidige speler.
  Set<YahtzeeCategory> get filledCategories {
    return scores[currentPlayer.id]?.keys.toSet() ?? {};
  }

  /// Geeft alle open categorieën voor de huidige speler.
  List<YahtzeeCategory> get openCategories {
    final filled = filledCategories;
    return YahtzeeCategory.values.where((c) => !filled.contains(c)).toList();
  }

  /// Totaalscore voor een speler.
  int totalFor(String playerId) {
    final playerScores = scores[playerId] ?? {};
    final bonusCount = yahtzeeBonusCounts[playerId] ?? 0;
    return YahtzeeEngine.grandTotal(playerScores, bonusCount);
  }

  /// Ranglijst: spelers gesorteerd op totaal, hoog naar laag.
  List<MapEntry<Player, int>> get ranking {
    final entries = players
        .map((p) => MapEntry(p, totalFor(p.id)))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Winnaar(s) — kan meerdere zijn bij gelijkspel.
  List<Player> get winners {
    final top = ranking.first.value;
    return ranking.where((e) => e.value == top).map((e) => e.key).toList();
  }

  // ── copyWith ──────────────────────────────────────────────────────────────

  YahtzeeGameState copyWith({
    int? currentPlayerIndex,
    int? round,
    List<int>? dice,
    List<bool>? kept,
    int? rollsRemaining,
    Map<String, Map<YahtzeeCategory, int>>? scores,
    Map<String, int>? yahtzeeBonusCounts,
    bool? isFinished,
  }) =>
      YahtzeeGameState(
        matchId: matchId,
        players: players,
        currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
        round: round ?? this.round,
        dice: dice ?? this.dice,
        kept: kept ?? this.kept,
        rollsRemaining: rollsRemaining ?? this.rollsRemaining,
        scores: scores ?? this.scores,
        yahtzeeBonusCounts: yahtzeeBonusCounts ?? this.yahtzeeBonusCounts,
        isFinished: isFinished ?? this.isFinished,
      );

  /// Beginstaat voor een nieuw potje.
  factory YahtzeeGameState.initial({
    required String matchId,
    required List<Player> players,
  }) =>
      YahtzeeGameState(
        matchId: matchId,
        players: players,
        currentPlayerIndex: 0,
        round: 1,
        dice: const [0, 0, 0, 0, 0],
        kept: const [false, false, false, false, false],
        rollsRemaining: 3,
        scores: {for (final p in players) p.id: {}},
        yahtzeeBonusCounts: {for (final p in players) p.id: 0},
      );
}
