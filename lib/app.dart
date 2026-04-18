import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// De root van de app.
///
/// Hier configureren we:
/// - Thema (light + dark, automatisch op basis van systeemvoorkeur)
/// - Talen (NL + EN, automatisch op basis van systeemtaal)
/// - Routing (welke URL leidt naar welk scherm)
class ScoreApp extends StatelessWidget {
  const ScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Naam van de app (verschijnt in recente apps op de telefoon)
      title: 'Score',

      // Thema
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system, // Volgt de telefooninstellingen

      // i18n: ondersteunde talen
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // Routing
      routerConfig: appRouter,

      // Verberg de "debug"-banner rechtsboven
      debugShowCheckedModeBanner: false,
    );
  }
}
