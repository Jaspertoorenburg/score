import 'package:uuid/uuid.dart';

/// Één onveranderlijk score-moment tijdens een potje.
///
/// We slaan scores op als een reeks events (event-sourcing).
/// Voordeel: later kunnen we sync bouwen door events te vergelijken.
/// Elk event bevat: wie scoorde, welke categorie, hoeveel punten.
class ScoreEvent {
  final String id;
  final DateTime timestamp;
  final String playerId;

  /// Spelspecifieke categorienaam, bv. 'yahtzee_ones', 'yahtzee_fullHouse'.
  final String category;
  final int score;

  /// Extra speldata (bv. de dobbelsteenwaarden bij dit moment).
  final Map<String, dynamic> metadata;

  const ScoreEvent({
    required this.id,
    required this.timestamp,
    required this.playerId,
    required this.category,
    required this.score,
    this.metadata = const {},
  });

  factory ScoreEvent.create({
    required String playerId,
    required String category,
    required int score,
    Map<String, dynamic> metadata = const {},
  }) =>
      ScoreEvent(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        playerId: playerId,
        category: category,
        score: score,
        metadata: metadata,
      );

  factory ScoreEvent.fromJson(Map<String, dynamic> json) => ScoreEvent(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        playerId: json['playerId'] as String,
        category: json['category'] as String,
        score: json['score'] as int,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'playerId': playerId,
        'category': category,
        'score': score,
        'metadata': metadata,
      };
}
