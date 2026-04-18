/// Alle scorecategorieën in klassiek Yahtzee.
///
/// Bovensectie (upper): punten = som van overeenkomende dobbelstenen.
/// Ondersectie (lower): vaste of variabele punten op basis van combinaties.
enum YahtzeeCategory {
  // Bovensectie
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,

  // Ondersectie
  threeOfAKind,
  fourOfAKind,
  fullHouse,
  smallStraight,
  largeStraight,
  yahtzee,
  chance,
}

extension YahtzeeCategoryX on YahtzeeCategory {
  bool get isUpperSection {
    return index <= YahtzeeCategory.sixes.index;
  }

  /// Opslaanaam in de database (stabiel, nooit veranderen).
  String get key => 'yahtzee_${name}';
}

/// Alle categorieën in de juiste volgorde voor de scorekaart.
const List<YahtzeeCategory> upperCategories = [
  YahtzeeCategory.ones,
  YahtzeeCategory.twos,
  YahtzeeCategory.threes,
  YahtzeeCategory.fours,
  YahtzeeCategory.fives,
  YahtzeeCategory.sixes,
];

const List<YahtzeeCategory> lowerCategories = [
  YahtzeeCategory.threeOfAKind,
  YahtzeeCategory.fourOfAKind,
  YahtzeeCategory.fullHouse,
  YahtzeeCategory.smallStraight,
  YahtzeeCategory.largeStraight,
  YahtzeeCategory.yahtzee,
  YahtzeeCategory.chance,
];
