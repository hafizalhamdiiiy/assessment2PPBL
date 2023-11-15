import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'opangatimin.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tukangojek(
            id INTEGER PRIMARY KEY,
            nama TEXT,
            nopol TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE transaksi(
            id INTEGER PRIMARY KEY,
            tukangojek_id INTEGER,
            harga INTEGER,
            timestamp TEXT,
            FOREIGN KEY (tukangojek_id) REFERENCES tukangojek(id)
          )
        ''');
      },
      version: 1,
    );
  }
}
