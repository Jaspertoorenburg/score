import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/player.dart';
import '../../data/repositories/player_repository.dart';
import '../../games/yahtzee/yahtzee_notifier.dart';

class YahtzeeSetupScreen extends ConsumerStatefulWidget {
  const YahtzeeSetupScreen({super.key});

  @override
  ConsumerState<YahtzeeSetupScreen> createState() => _YahtzeeSetupScreenState();
}

class _YahtzeeSetupScreenState extends ConsumerState<YahtzeeSetupScreen> {
  final Set<String> _selectedIds = {};
  final _quickAddController = TextEditingController();

  @override
  void dispose() {
    _quickAddController.dispose();
    super.dispose();
  }

  void _togglePlayer(Player player) {
    setState(() {
      if (_selectedIds.contains(player.id)) {
        _selectedIds.remove(player.id);
      } else {
        _selectedIds.add(player.id);
      }
    });
  }

  Future<void> _quickAdd(List<Player> existingPlayers) async {
    final name = _quickAddController.text.trim();
    if (name.isEmpty) return;

    final newPlayer = Player.create(name);
    await ref.read(playerRepositoryProvider).save(newPlayer);
    _quickAddController.clear();
    setState(() => _selectedIds.add(newPlayer.id));
  }

  void _startGame(List<Player> allPlayers) {
    final selected = allPlayers.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.setup_minPlayers),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref.read(yahtzeeGameProvider.notifier).startGame(selected);
    context.go('/game/yahtzee/play');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playersAsync = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setup_title)),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (players) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.setup_selectPlayers,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (players.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.setup_noPlayers,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  else
                    ...players.map(
                      (p) => _PlayerCheckTile(
                        player: p,
                        selected: _selectedIds.contains(p.id),
                        onToggle: () => _togglePlayer(p),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    l10n.setup_quickAdd,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quickAddController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: l10n.players_namePlaceholder,
                          ),
                          onSubmitted: (_) => _quickAdd(players),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => _quickAdd(players),
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ElevatedButton(
                onPressed: () => _startGame(players),
                child: Text(
                  '${l10n.setup_startGame}'
                  '${_selectedIds.isNotEmpty ? ' (${_selectedIds.length})' : ''}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerCheckTile extends StatelessWidget {
  final Player player;
  final bool selected;
  final VoidCallback onToggle;

  const _PlayerCheckTile({
    required this.player,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: selected ? AppColors.primaryContainer : null,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    selected ? AppColors.primary : AppColors.surfaceLight,
                child: Text(
                  player.name[0].toUpperCase(),
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
