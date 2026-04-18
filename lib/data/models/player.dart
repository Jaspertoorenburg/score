import 'package:uuid/uuid.dart';

/// Een globale speler die los van potjes bestaat.
/// Spelers worden hergebruikt over meerdere potjes heen.
class Player {
  final String id;
  final String name;
  final DateTime createdAt;

  const Player({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// Maak een nieuwe speler aan met automatisch gegenereerd ID.
  factory Player.create(String name) => Player(
        id: const Uuid().v4(),
        name: name.trim(),
        createdAt: DateTime.now(),
      );

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
      };

  Player copyWith({String? name}) => Player(
        id: id,
        name: name ?? this.name,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) => other is Player && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Player($name)';
}
