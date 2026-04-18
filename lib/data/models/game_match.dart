import 'package:uuid/uuid.dart';
import 'score_event.dart';

/// Een gespeeld potje.
/// Bevat alle metadata en een lijst van score-events.
class GameMatch {
  final String id;

  /// Identifier van het spel, bv. 'yahtzee'. Later ook 'darts_501', 'klaverjas'.
  final String gameId;

  final List<String> playerIds;
  final DateTime startedAt;
  final DateTime? finishedAt;

  /// ID van de winnende speler, of null bij gelijkspel of lopend spel.
  final String? winnerId;

  /// Chronologische lijst van alle score-momenten.
  final List<ScoreEvent> events;

  const GameMatch({
    required this.id,
    required this.gameId,
    required this.playerIds,
    required this.startedAt,
    this.finishedAt,
    this.winnerId,
    this.events = const [],
  });

  factory GameMatch.create({
    required String gameId,
    required List<String> playerIds,
  }) =>
      GameMatch(
        id: const Uuid().v4(),
        gameId: gameId,
        playerIds: List.unmodifiable(playerIds),
        startedAt: DateTime.now(),
      );

  factory GameMatch.fromJson(Map<String, dynamic> json) => GameMatch(
        id: json['id'] as String,
        gameId: json['gameId'] as String,
        playerIds: List<String>.from(json['playerIds'] as List),
        startedAt: DateTime.parse(json['startedAt'] as String),
        finishedAt: json['finishedAt'] != null
            ? DateTime.parse(json['finishedAt'] as String)
            : null,
        winnerId: json['winnerId'] as String?,
        events: (json['events'] as List<dynamic>? ?? [])
            .map((e) => ScoreEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'playerIds': playerIds,
        'startedAt': startedAt.toIso8601String(),
        'finishedAt': finishedAt?.toIso8601String(),
        'winnerId': winnerId,
        'events': events.map((e) => e.toJson()).toList(),
      };

  GameMatch copyWith({
    DateTime? finishedAt,
    String? winnerId,
    List<ScoreEvent>? events,
  }) =>
      GameMatch(
        id: id,
        gameId: gameId,
        playerIds: playerIds,
        startedAt: startedAt,
        finishedAt: finishedAt ?? this.finishedAt,
        winnerId: winnerId ?? this.winnerId,
        events: events ?? this.events,
      );

  bool get isFinished => finishedAt != null;
}
