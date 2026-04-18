import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/game_match.dart';
import '../../data/models/player.dart';
import '../../data/models/score_event.dart';
import '../../data/repositories/match_repository.dart';
import 'yahtzee_categories.dart';
import 'yahtzee_engine.dart';
import 'yahtzee_state.dart';

final _random = Random();

/// Beheert alle acties tijdens een Yahtzee-potje.
///
/// StateNotifier houdt de toestand bij en stuurt de UI opnieuw op
/// elke keer als er iets verandert.
class YahtzeeGameNotifier extends StateNotifier<YahtzeeGameState?> {
  final Ref _ref;

  YahtzeeGameNotifier(this._ref) : super(null);

  /// Start een nieuw potje met de gegeven spelers.
  void startGame(List<Player> players) {
    final match = GameMatch.create(
      gameId: 'yahtzee',
      playerIds: players.map((p) => p.id).toList(),
    );
    state = YahtzeeGameState.initial(
      matchId: match.id,
      players: players,
    );
    // Sla het potje meteen op zodat het in de geschiedenis verschijnt.
    _ref.read(matchRepositoryProvider).save(match);
  }

  /// Gooit de dobbelstenen die niet bewaard worden.
  void rollDice() {
    final s = state;
    if (s == null || !s.canRoll) return;

    final newDice = List<int>.generate(5, (i) {
      return s.kept[i] ? s.dice[i] : (_random.nextInt(6) + 1);
    });

    state = s.copyWith(
      dice: newDice,
      rollsRemaining: s.rollsRemaining - 1,
    );
  }

  /// Zet de "bewaar"-status van dobbelsteen [index] om.
  void toggleKeep(int index) {
    final s = state;
    if (s == null || !s.hasRolled) return;

    final newKept = List<bool>.from(s.kept);
    newKept[index] = !newKept[index];
    state = s.copyWith(kept: newKept);
  }

  /// Scoort de gekozen categorie voor de huidige speler en gaat naar de volgende beurt.
  Future<void> scoreCategory(YahtzeeCategory category) async {
    final s = state;
    if (s == null || !s.hasRolled) return;
    if (s.filledCategories.contains(category)) return; // al ingevuld

    final playerId = s.currentPlayer.id;
    final points = YahtzeeEngine.calculate(category, s.dice);

    // Controleer op Yahtzee-bonus (extra Yahtzee na de eerste 50-punten-score).
    final isExtraYahtzee = category == YahtzeeCategory.yahtzee &&
        (s.scores[playerId]?[YahtzeeCategory.yahtzee] != null) &&
        YahtzeeEngine.calculate(YahtzeeCategory.yahtzee, s.dice) == 50;

    // Bouw nieuwe scores op.
    final updatedPlayerScores = Map<YahtzeeCategory, int>.from(
      s.scores[playerId] ?? {},
    )..[category] = points;

    final updatedScores = Map<String, Map<YahtzeeCategory, int>>.from(s.scores)
      ..[playerId] = updatedPlayerScores;

    final updatedBonuses = Map<String, int>.from(s.yahtzeeBonusCounts);
    if (isExtraYahtzee) {
      updatedBonuses[playerId] = (updatedBonuses[playerId] ?? 0) + 1;
    }

    // Sla event op in de database.
    await _saveEvent(
      matchId: s.matchId,
      playerId: playerId,
      category: category,
      score: points,
      dice: s.dice,
    );

    // Bepaal wie de volgende speler is en of het spel klaar is.
    final nextPlayerIndex = (s.currentPlayerIndex + 1) % s.players.length;
    final isLastPlayerOfRound = nextPlayerIndex == 0;
    final nextRound = isLastPlayerOfRound ? s.round + 1 : s.round;
    final gameFinished = isLastPlayerOfRound && s.round == 13;

    if (gameFinished) {
      await _finishGame(
        matchId: s.matchId,
        updatedScores: updatedScores,
        updatedBonuses: updatedBonuses,
        players: s.players,
      );
    }

    state = s.copyWith(
      scores: updatedScores,
      yahtzeeBonusCounts: updatedBonuses,
      currentPlayerIndex: gameFinished ? s.currentPlayerIndex : nextPlayerIndex,
      round: gameFinished ? s.round : nextRound,
      dice: const [0, 0, 0, 0, 0],
      kept: const [false, false, false, false, false],
      rollsRemaining: 3,
      isFinished: gameFinished,
    );
  }

  // ── Private hulpfuncties ──────────────────────────────────────────────────

  Future<void> _saveEvent({
    required String matchId,
    required String playerId,
    required YahtzeeCategory category,
    required int score,
    required List<int> dice,
  }) async {
    final repo = _ref.read(matchRepositoryProvider);
    final match = await repo.getById(matchId);
    if (match == null) return;

    final event = ScoreEvent.create(
      playerId: playerId,
      category: category.key,
      score: score,
      metadata: {'dice': dice},
    );

    await repo.save(match.copyWith(events: [...match.events, event]));
  }

  Future<void> _finishGame({
    required String matchId,
    required Map<String, Map<YahtzeeCategory, int>> updatedScores,
    required Map<String, int> updatedBonuses,
    required List<Player> players,
  }) async {
    final repo = _ref.read(matchRepositoryProvider);
    final match = await repo.getById(matchId);
    if (match == null) return;

    // Bepaal winnaar.
    final totals = {
      for (final p in players)
        p.id: YahtzeeEngine.grandTotal(
          updatedScores[p.id] ?? {},
          updatedBonuses[p.id] ?? 0,
        ),
    };
    final maxScore = totals.values.reduce((a, b) => a > b ? a : b);
    final topPlayers = totals.entries
        .where((e) => e.value == maxScore)
        .map((e) => e.key)
        .toList();

    await repo.save(
      match.copyWith(
        finishedAt: DateTime.now(),
        winnerId: topPlayers.length == 1 ? topPlayers.first : null,
      ),
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final yahtzeeGameProvider =
    StateNotifierProvider<YahtzeeGameNotifier, YahtzeeGameState?>(
  (ref) => YahtzeeGameNotifier(ref),
);
