# Score — Setup-instructies

Volg deze stappen om de app op je computer draaiend te krijgen.

---

## Stap 1: Flutter installeren

1. Ga naar https://docs.flutter.dev/get-started/install/windows
2. Download de Flutter SDK en pak hem uit naar `C:\src\flutter`
   (let op: geen spaties in het pad)
3. Voeg `C:\src\flutter\bin` toe aan je Windows PATH:
   - Zoek op "omgevingsvariabelen" in het Startmenu
   - Klik "Omgevingsvariabelen bewerken"
   - Selecteer "Path" → Bewerken → Nieuw → plak `C:\src\flutter\bin`
   - OK, OK, OK
4. Open PowerShell en test: `flutter --version`
   (je ziet een versienummer als het goed is)

## Stap 2: Android Studio installeren

1. Ga naar https://developer.android.com/studio en installeer
2. Tijdens de setup: vink "Android Virtual Device" aan (de emulator)
3. Na installatie: open Android Studio → More Actions → SDK Manager
4. Installeer "Android SDK Platform 34" als dat nog niet staat

## Stap 3: VS Code installeren

1. Ga naar https://code.visualstudio.com en installeer
2. Open VS Code → Extensions (Ctrl+Shift+X) → zoek "Flutter" → Install
   (de Dart-extensie wordt automatisch meegeïnstalleerd)

## Stap 4: Flutter doctor uitvoeren

Open PowerShell en typ:
```
flutter doctor
```

Je ziet een lijst met checks. Je wil minimaal groen bij:
- Flutter ✓
- Android toolchain ✓
- VS Code ✓

Het vinkje bij "Xcode" blijft rood op Windows — dat is normaal.

Als je een melding krijgt over "Android licenses not accepted":
```
flutter doctor --android-licenses
```
Beantwoord alles met `y`.

## Stap 5: Het project klaarmaken

1. Open een terminal/PowerShell in de map waar `score/` staat
2. Ga de projectmap in:
   ```
   cd score
   ```
3. Maak een nieuw Flutter-project aan (dit genereert de Android/iOS boilerplate):
   ```
   flutter create . --org nl.budgetthuis --platforms android,ios
   ```
   > Let op de punt (.) — die zegt "in de huidige map".
   > Dit overschrijft alleen de platformbestanden, niet onze code in `lib/`.

4. Installeer de packages:
   ```
   flutter pub get
   ```

## Stap 6: De app starten

1. Start een Android-emulator:
   - Vanuit Android Studio: Tools → Device Manager → Start een virtueel apparaat
   - Of vanuit de terminal: `flutter emulators --launch <naam>`

2. Start de app:
   ```
   flutter run
   ```
   > Flutter vraagt op welk apparaat je wil starten als er meerdere zijn.
   > Kies de Android-emulator.

3. Je ziet de app verschijnen met het Score-startscherm. 🎲

## Stap 7: Tests uitvoeren

```
flutter test
```

Je ziet de Yahtzee-engine tests draaien. Alles groen = scoring-logica correct.

---

## Veelgestelde problemen

**"Gradle build failed"** bij de eerste run:
Wacht even, de eerste build duurt 3–5 minuten (Gradle downloadt dingen).

**"SDK not found"**:
Controleer of Android Studio en de Android SDK correct zijn geïnstalleerd
en of `flutter doctor` groen is bij Android toolchain.

**"No devices found"**:
Zorg dat de Android-emulator draait voordat je `flutter run` typt.

---

## iOS testen (via Codemagic)

Voor iOS-builds op je iPhone (zonder Mac):
1. Maak een account aan op https://codemagic.io
2. Verbind je Git-repository (GitHub/GitLab/Bitbucket)
3. Codemagic detecteert Flutter automatisch
4. Elke build gaat naar TestFlight — installeer die op je iPhone

Instructies volgen wanneer we aan store-submission toe zijn.

---

## Projectstructuur (kort overzicht)

```
lib/
├── main.dart              ← Startpunt, opent database, start app
├── app.dart               ← Root: thema, talen, routing
├── core/
│   ├── theme/             ← Kleuren en stijlen (Palet A — Game Night)
│   └── router/            ← Alle routes van de app
├── data/
│   ├── models/            ← Player, GameMatch, ScoreEvent
│   └── repositories/      ← Lees/schrijf-logica voor de database
├── games/
│   └── yahtzee/           ← Alle Yahtzee-logica (engine, state, notifier)
│       ├── yahtzee_engine.dart    ← Puur de scoringsregels
│       ├── yahtzee_state.dart     ← Wat er tijdens een potje bijgehouden wordt
│       └── yahtzee_notifier.dart  ← Acties: gooien, bewaren, scoren
└── features/
    ├── home/              ← Startscherm (kies een spel)
    ├── players/           ← Spelerbeheer
    ├── yahtzee_setup/     ← Spelers kiezen voor een potje
    ├── yahtzee_play/      ← Het spelscherm met dobbelstenen en scorekaart
    ├── yahtzee_result/    ← Eindscherm met winnaar
    └── history/           ← Gespeelde potjes
```
