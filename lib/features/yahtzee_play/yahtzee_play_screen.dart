import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../games/yahtzee/yahtzee_categories.dart';
import '../../games/yahtzee/yahtzee_notifier.dart';
import '../../games/yahtzee/yahtzee_state.dart';
import 'widgets/dice_widget.dart';
import 'widgets/scorecard_sheet.dart';

class YahtzeePlayScreen extends ConsumerWidget {
  const YahtzeePlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(yahtzeeGameProvider);

    if (gameState == null) {
      // Geen actief spel — stuur terug naar home.
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (gameState.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go('/game/yahtzee/result'),
      );
    }

    return _YahtzeePlayView(gameState: gameState);
  }
}

class _YahtzeePlayView extends ConsumerWidget {
  final YahtzeeGameState gameState;

  const _YahtzeePlayView({required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(yahtzeeGameProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yahtzee_round(gameState.round)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context),
        ),
        actions: [
          // Knop om andere spelers' scorekaarten te bekijken
          if (gameState.players.length > 1)
            IconButton(
              icon: const Icon(Icons.leaderboard_outlined),
              onPressed: () => _showAllScores(context, ref),
              tooltip: 'Alle scores',
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Huidige speler ─────────────────────────────────────────────
          _PlayerHeader(gameState: gameState),

          // ── Dobbelstenen ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: DiceWidget(
                    value: gameState.dice[i],
                    kept: gameState.kept[i],
                    enabled: gameState.hasRolled,
                    onTap: () => notifier.toggleKeep(i),
                  ),
                ),
              ),
            ),
          ),

          // ── Gooi-knop ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: gameState.canRoll ? notifier.rollDice : null,
                  child: Text(l10n.yahtzee_roll),
                ),
                const SizedBox(height: 6),
                Text(
                  gameState.mustScore
                      ? l10n.yahtzee_mustScore
                      : gameState.hasRolled
                          ? l10n.yahtzee_rollsLeft(gameState.rollsRemaining)
                          : l10n.yahtzee_rollsLeft(3),
                  style: TextStyle(
                    color: gameState.mustScore
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: gameState.mustScore
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // ── Scorekaart (scrollbaar) ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: ScorecardSheet(
                gameState: gameState,
                onSelectCategory: (cat) => _scoreCategory(context, ref, cat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scoreCategory(
    BuildContext context,
    WidgetRef ref,
    YahtzeeCategory cat,
  ) async {
    await ref.read(yahtzeeGameProvider.notifier).scoreCategory(cat);
  }

  Future<void> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Spel verlaten?'),
        content: const Text(
          'Het huidige spel wordt niet opgeslagen als je nu stopt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Doorgaan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Verlaten'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.go('/');
    }
  }

  void _showAllScores(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (context, controller) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: gameState.players.map((player) {
                    return SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Totaal: ${gameState.totalFor(player.id)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final YahtzeeGameState gameState;
  const _PlayerHeader({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      color: AppColors.primaryContainer,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        l10n.yahtzee_currentPlayer(gameState.currentPlayer.name),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
