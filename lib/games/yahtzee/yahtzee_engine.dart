import 'yahtzee_categories.dart';

/// Bevat alle scorings-regels voor klassiek Yahtzee.
///
/// Puur functioneel: geen state, geen UI. Alleen berekeningen.
/// Dit maakt het makkelijk te testen en los te houden van de UI.
abstract final class YahtzeeEngine {
  /// Berekent de potentiële score voor een categorie op basis van de dobbelstenen.
  /// Geeft 0 terug als de combinatie niet geldig is voor die categorie.
  static int calculate(YahtzeeCategory category, List<int> dice) {
    assert(dice.length == 5, 'Yahtzee vereist precies 5 dobbelstenen');
    return switch (category) {
      YahtzeeCategory.ones => _sumOf(dice, 1),
      YahtzeeCategory.twos => _sumOf(dice, 2),
      YahtzeeCategory.threes => _sumOf(dice, 3),
      YahtzeeCategory.fours => _sumOf(dice, 4),
      YahtzeeCategory.fives => _sumOf(dice, 5),
      YahtzeeCategory.sixes => _sumOf(dice, 6),
      YahtzeeCategory.threeOfAKind => _nOfAKind(dice, 3) ? _total(dice) : 0,
      YahtzeeCategory.fourOfAKind => _nOfAKind(dice, 4) ? _total(dice) : 0,
      YahtzeeCategory.fullHouse => _isFullHouse(dice) ? 25 : 0,
      YahtzeeCategory.smallStraight => _isSmallStraight(dice) ? 30 : 0,
      YahtzeeCategory.largeStraight => _isLargeStraight(dice) ? 40 : 0,
      YahtzeeCategory.yahtzee => _isYahtzee(dice) ? 50 : 0,
      YahtzeeCategory.chance => _total(dice),
    };
  }

  /// Berekent de bovenste subtotaal van een scorekaart.
  static int upperSubtotal(Map<YahtzeeCategory, int> scores) {
    return upperCategories.fold(
      0,
      (sum, cat) => sum + (scores[cat] ?? 0),
    );
  }

  /// Geeft 35 als de bovenste subtotaal >= 63 is, anders 0.
  static int upperBonus(Map<YahtzeeCategory, int> scores) {
    return upperSubtotal(scores) >= 63 ? 35 : 0;
  }

  /// Berekent het eindtotaal inclusief bonus en eventuele extra Yahtzees.
  static int grandTotal(Map<YahtzeeCategory, int> scores, int yahtzeeBonusCount) {
    final lower = lowerCategories.fold(0, (sum, cat) => sum + (scores[cat] ?? 0));
    return upperSubtotal(scores) +
        upperBonus(scores) +
        lower +
        yahtzeeBonusCount * 100;
  }

  // ── Private hulpfuncties ──────────────────────────────────────────────────

  static int _sumOf(List<int> dice, int value) =>
      dice.where((d) => d == value).fold(0, (a, b) => a + b);

  static int _total(List<int> dice) => dice.fold(0, (a, b) => a + b);

  static Map<int, int> _counts(List<int> dice) {
    final counts = <int, int>{};
    for (final d in dice) {
      counts[d] = (counts[d] ?? 0) + 1;
    }
    return counts;
  }

  static bool _nOfAKind(List<int> dice, int n) =>
      _counts(dice).values.any((count) => count >= n);

  static bool _isFullHouse(List<int> dice) {
    final values = _counts(dice).values.toList()..sort();
    return values.length == 2 && values[0] == 2 && values[1] == 3;
  }

  static bool _isSmallStraight(List<int> dice) {
    final unique = dice.toSet();
    // Drie mogelijke kleine straten: 1-2-3-4, 2-3-4-5, 3-4-5-6
    return ({1, 2, 3, 4}.every(unique.contains)) ||
        ({2, 3, 4, 5}.every(unique.contains)) ||
        ({3, 4, 5, 6}.every(unique.contains));
  }

  static bool _isLargeStraight(List<int> dice) {
    final sorted = dice.toList()..sort();
    // 1-2-3-4-5 of 2-3-4-5-6
    return sorted.toString() == '[1, 2, 3, 4, 5]' ||
        sorted.toString() == '[2, 3, 4, 5, 6]';
  }

  static bool _isYahtzee(List<int> dice) => dice.every((d) => d == dice[0]);
}
