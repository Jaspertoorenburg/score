import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Opent de lokale Sembast-database.
/// Wordt eenmalig aangeroepen in main.dart vóór de app start.
///
/// Sembast slaat data op als JSON in een bestand op het apparaat.
/// Het bestand staat in de app-documenten-map (niet zichtbaar voor de gebruiker).
Future<Database> openAppDatabase() async {
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(appDir.path, 'score_v1.db');
  return databaseFactoryIo.openDatabase(dbPath);
}
