import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo / titel
              Text(
                '🎲',
                style: const TextStyle(fontSize: 64),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appTitle,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Spellen
              Text(
                l10n.home_chooseGame,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _GameTile(
                emoji: '🎲',
                title: 'Yahtzee',
                subtitle: 'Klassiek • 1–6 spelers',
                onTap: () => context.push('/game/yahtzee/setup'),
              ),
              const SizedBox(height: 8),
              // Placeholder voor toekomstige spellen
              _GameTile(
                emoji: '🎯',
                title: 'Darts 501',
                subtitle: 'Binnenkort beschikbaar',
                enabled: false,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _GameTile(
                emoji: '🃏',
                title: 'Klaverjassen',
                subtitle: 'Binnenkort beschikbaar',
                enabled: false,
                onTap: () {},
              ),

              const Spacer(),

              // Navigatie-knoppen onderaan
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.people_outline),
                      label: Text(l10n.home_players),
                      onPressed: () => context.push('/players'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.history_outlined),
                      label: Text(l10n.home_history),
                      onPressed: () => context.push('/history'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  const _GameTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Card(
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: undefined_identifier
// Dit is een import-placeholder — Flutter genereert dit bestand automatisch
// vanuit de ARB-bestanden in lib/l10n/. Zie pubspec.yaml → flutter.generate: true
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
