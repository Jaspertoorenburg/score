import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../games/yahtzee/yahtzee_categories.dart';
import '../../../games/yahtzee/yahtzee_engine.dart';
import '../../../games/yahtzee/yahtzee_state.dart';

/// De interactieve scorekaart voor de huidige speler.
///
/// Open categorieën tonen een preview van de mogelijke score.
/// Tikken op een open categorie kent die score toe.
class ScorecardSheet extends StatelessWidget {
  final YahtzeeGameState gameState;
  final void Function(YahtzeeCategory) onSelectCategory;

  const ScorecardSheet({
    super.key,
    required this.gameState,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playerId = gameState.currentPlayer.id;
    final playerScores = gameState.scores[playerId] ?? {};
    final dice = gameState.dice;
    final canScore = gameState.hasRolled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Bovensectie ─────────────────────────────────────────────────────
        _SectionHeader(label: l10n.yahtzee_upper),
        ...upperCategories.map(
          (cat) => _CategoryRow(
            label: _categoryLabel(cat, l10n),
            scored: playerScores[cat],
            preview: canScore && !playerScores.containsKey(cat)
                ? YahtzeeEngine.calculate(cat, dice)
                : null,
            onTap: canScore && !playerScores.containsKey(cat)
                ? () => onSelectCategory(cat)
                : null,
          ),
        ),
        _BonusRow(
          subtotal: YahtzeeEngine.upperSubtotal(playerScores),
          bonus: YahtzeeEngine.upperBonus(playerScores),
          l10n: l10n,
        ),
        const Divider(height: 1),

        // ── Ondersectie ──────────────────────────────────────────────────────
        _SectionHeader(label: l10n.yahtzee_lower),
        ...lowerCategories.map(
          (cat) => _CategoryRow(
            label: _categoryLabel(cat, l10n),
            scored: playerScores[cat],
            preview: canScore && !playerScores.containsKey(cat)
                ? YahtzeeEngine.calculate(cat, dice)
                : null,
            onTap: canScore && !playerScores.containsKey(cat)
                ? () => onSelectCategory(cat)
                : null,
          ),
        ),

        // Extra Yahtzee-bonussen
        if ((gameState.yahtzeeBonusCounts[playerId] ?? 0) > 0)
          _TotalRow(
            label: l10n.yahtzee_yahtzeeBonusLabel,
            value:
                '+${(gameState.yahtzeeBonusCounts[playerId] ?? 0) * 100}',
            color: AppColors.success,
          ),

        const Divider(height: 1),
        _TotalRow(
          label: l10n.yahtzee_total,
          value: gameState.totalFor(playerId).toString(),
          bold: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _categoryLabel(YahtzeeCategory cat, AppLocalizations l10n) =>
      switch (cat) {
        YahtzeeCategory.ones => l10n.yahtzee_cat_ones,
        YahtzeeCategory.twos => l10n.yahtzee_cat_twos,
        YahtzeeCategory.threes => l10n.yahtzee_cat_threes,
        YahtzeeCategory.fours => l10n.yahtzee_cat_fours,
        YahtzeeCategory.fives => l10n.yahtzee_cat_fives,
        YahtzeeCategory.sixes => l10n.yahtzee_cat_sixes,
        YahtzeeCategory.threeOfAKind => l10n.yahtzee_cat_threeOfAKind,
        YahtzeeCategory.fourOfAKind => l10n.yahtzee_cat_fourOfAKind,
        YahtzeeCategory.fullHouse => l10n.yahtzee_cat_fullHouse,
        YahtzeeCategory.smallStraight => l10n.yahtzee_cat_smallStraight,
        YahtzeeCategory.largeStraight => l10n.yahtzee_cat_largeStraight,
        YahtzeeCategory.yahtzee => l10n.yahtzee_cat_yahtzee,
        YahtzeeCategory.chance => l10n.yahtzee_cat_chance,
      };
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textMuted,
          ),
        ),
      );
}

class _CategoryRow extends StatelessWidget {
  final String label;
  final int? scored; // null = open
  final int? preview; // score als je nu zou kiezen
  final VoidCallback? onTap;

  const _CategoryRow({
    required this.label,
    this.scored,
    this.preview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = scored != null;
    final canTap = onTap != null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight:
                      isFilled ? FontWeight.w500 : FontWeight.w600,
                  color:
                      isFilled ? AppColors.textMuted : AppColors.textPrimary,
                ),
              ),
            ),
            if (isFilled)
              Text(
                scored.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              )
            else if (preview != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: preview! > 0
                      ? AppColors.accentContainer
                      : AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  preview.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: preview! > 0
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              )
            else
              const Text(
                '—',
                style: TextStyle(color: AppColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  final int subtotal;
  final int bonus;
  final AppLocalizations l10n;

  const _BonusRow({
    required this.subtotal,
    required this.bonus,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final achieved = bonus > 0;
    return Container(
      color: achieved ? AppColors.successContainer : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.yahtzee_bonus,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: achieved ? AppColors.success : AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                if (!achieved)
                  Text(
                    l10n.yahtzee_bonusProgress(subtotal),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            achieved ? '+35' : '—',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: achieved ? AppColors.success : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: color ?? AppColors.textPrimary,
                  fontSize: bold ? 16 : 14,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                color: color ?? AppColors.textPrimary,
                fontSize: bold ? 18 : 14,
              ),
            ),
          ],
        ),
      );
}
