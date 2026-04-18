import 'package:flutter_test/flutter_test.dart';
import 'package:score/games/yahtzee/yahtzee_categories.dart';
import 'package:score/games/yahtzee/yahtzee_engine.dart';

void main() {
  group('YahtzeeEngine — bovensectie', () {
    test('enen: telt alle 1-en op', () {
      expect(YahtzeeEngine.calculate(YahtzeeCategory.ones, [1, 1, 2, 3, 4]), 2);
      expect(YahtzeeEngine.calculate(YahtzeeCategory.ones, [1, 1, 1, 1, 1]), 5);
      expect(YahtzeeEngine.calculate(YahtzeeCategory.ones, [2, 3, 4, 5, 6]), 0);
    });

    test('tweeën: telt alle 2-en op', () {
      expect(YahtzeeEngine.calculate(YahtzeeCategory.twos, [2, 2, 3, 4, 5]), 4);
    });

    test('zessen: telt alle 6-en op', () {
      expect(YahtzeeEngine.calculate(YahtzeeCategory.sixes, [6, 6, 6, 1, 2]), 18);
    });
  });

  group('YahtzeeEngine — ondersectie', () {
    test('drie van een soort: som van alle dobbelstenen', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.threeOfAKind, [3, 3, 3, 2, 1]),
        12,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.threeOfAKind, [1, 2, 3, 4, 5]),
        0,
      );
    });

    test('vier van een soort: som van alle dobbelstenen', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.fourOfAKind, [4, 4, 4, 4, 2]),
        18,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.fourOfAKind, [3, 3, 3, 2, 1]),
        0,
      );
    });

    test('full house: 25 punten', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.fullHouse, [2, 2, 3, 3, 3]),
        25,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.fullHouse, [1, 1, 1, 1, 2]),
        0,
      );
    });

    test('kleine straat: 30 punten voor 4 opeenvolgende', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.smallStraight, [1, 2, 3, 4, 1]),
        30,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.smallStraight, [2, 3, 4, 5, 2]),
        30,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.smallStraight, [3, 4, 5, 6, 6]),
        30,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.smallStraight, [1, 2, 3, 5, 6]),
        0,
      );
    });

    test('grote straat: 40 punten voor 5 opeenvolgende', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.largeStraight, [1, 2, 3, 4, 5]),
        40,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.largeStraight, [2, 3, 4, 5, 6]),
        40,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.largeStraight, [1, 2, 3, 4, 6]),
        0,
      );
    });

    test('yahtzee: 50 punten voor 5 gelijke', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.yahtzee, [5, 5, 5, 5, 5]),
        50,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.yahtzee, [5, 5, 5, 5, 4]),
        0,
      );
    });

    test('vrije keuze: som van alle dobbelstenen', () {
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.chance, [1, 2, 3, 4, 5]),
        15,
      );
      expect(
        YahtzeeEngine.calculate(YahtzeeCategory.chance, [6, 6, 6, 6, 6]),
        30,
      );
    });
  });

  group('YahtzeeEngine — bonus en totaal', () {
    test('upperBonus: 35 als subtotaal >= 63', () {
      // Precies 63: drie van elke waarde
      final scores = {
        YahtzeeCategory.ones: 3,    // 3×1
        YahtzeeCategory.twos: 6,    // 3×2
        YahtzeeCategory.threes: 9,  // 3×3
        YahtzeeCategory.fours: 12,  // 3×4
        YahtzeeCategory.fives: 15,  // 3×5
        YahtzeeCategory.sixes: 18,  // 3×6 → totaal 63
      };
      expect(YahtzeeEngine.upperBonus(scores), 35);
    });

    test('upperBonus: 0 als subtotaal < 63', () {
      final scores = {
        YahtzeeCategory.ones: 1,
        YahtzeeCategory.twos: 2,
      };
      expect(YahtzeeEngine.upperBonus(scores), 0);
    });

    test('grandTotal: telt alles correct op inclusief Yahtzee-bonussen', () {
      final scores = {
        YahtzeeCategory.ones: 3,
        YahtzeeCategory.twos: 6,
        YahtzeeCategory.threes: 9,
        YahtzeeCategory.fours: 12,
        YahtzeeCategory.fives: 15,
        YahtzeeCategory.sixes: 18,   // bovensubtotaal = 63 → +35 bonus
        YahtzeeCategory.yahtzee: 50,
        YahtzeeCategory.chance: 20,
      };
      // 63 + 35 (bonus) + 50 + 20 + 2×100 (extra yahtzees) = 368
      expect(YahtzeeEngine.grandTotal(scores, 2), 368);
    });
  });
}
