import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/game_match.dart';
import '../../data/models/player.dart';
import '../../data/repositories/match_repository.dart';
import '../../data/repositories/player_repository.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final matchesAsync = ref.watch(matchesProvider);
    final playersAsync = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history_title)),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (matches) {
          final finished = matches.where((m) => m.isFinished).toList();
          if (finished.isEmpty) {
            return Center(
              child: Text(
                l10n.history_empty,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          return playersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (players) {
              final playerMap = {for (final p in players) p.id: p};
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: finished.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _MatchTile(
                  match: finished[i],
                  playerMap: playerMap,
                  l10n: l10n,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final GameMatch match;
  final Map<String, Player> playerMap;
  final AppLocalizations l10n;

  const _MatchTile({
    required this.match,
    required this.playerMap,
    required this.l10n,
  });

  String get _gameLabel => switch (match.gameId) {
        'yahtzee' => '🎲 Yahtzee',
        'darts_501' => '🎯 Darts 501',
        'klaverjas' => '🃏 Klaverjassen',
        _ => match.gameId,
      };

  @override
  Widget build(BuildContext context) {
    final winner = match.winnerId != null ? playerMap[match.winnerId] : null;
    final dateLabel = match.finishedAt != null
        ? DateFormat('d MMM y — HH:mm').format(match.finishedAt!)
        : '—';
    final playerNames = match.playerIds
        .map((id) => playerMap[id]?.name ?? '?')
        .join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _gameLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              playerNames,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: winner != null
                    ? AppColors.primaryContainer
                    : AppColors.dividerLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                winner != null
                    ? l10n.history_winner(winner.name)
                    : l10n.history_tie,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: winner != null
                      ? AppColors.primaryDark
                      : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
