import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/player.dart';
import '../../games/yahtzee/yahtzee_notifier.dart';
import '../../games/yahtzee/yahtzee_state.dart';

class YahtzeeResultScreen extends ConsumerWidget {
  const YahtzeeResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(yahtzeeGameProvider);
    final l10n = AppLocalizations.of(context)!;

    if (gameState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
      return const Scaffold(body: SizedBox.shrink());
    }

    final winners = gameState.winners;
    final isTie = winners.length > 1;
    final ranking = gameState.ranking;

    return PopScope(
      canPop: false, // Geen "terug" tijdens eindscherm
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),

                // Winnaar-banner
                Text(
                  isTie ? l10n.result_tie : l10n.result_winner(winners.first.name),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Eindscores
                Text(
                  l10n.result_finalScores,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                ),
                const SizedBox(height: 12),
                ...ranking.asMap().entries.map(
                      (entry) => _ScoreRow(
                        rank: entry.key + 1,
                        player: entry.value.key,
                        score: entry.value.value,
                        isWinner: winners.contains(entry.value.key),
                      ),
                    ),

                const Spacer(),

                // Knoppen
                ElevatedButton(
                  onPressed: () {
                    ref.read(yahtzeeGameProvider.notifier).startGame(
                          gameState.players,
                        );
                    context.go('/game/yahtzee/play');
                  },
                  child: Text(l10n.result_newGame),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: Text(l10n.result_home),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final int rank;
  final Player player;
  final int score;
  final bool isWinner;

  const _ScoreRow({
    required this.rank,
    required this.player,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isWinner ? AppColors.primaryContainer : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWinner ? AppColors.primary : AppColors.dividerLight,
          width: isWinner ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isWinner ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            score.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isWinner ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
