import 'package:market_list_app/models/itemModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'lista_mercado.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      quantity INTEGER,
      status TEXT
    )''');
  }

  Future<void> insertItem(ItemModel item) async {
    final db = await instance.database;
    await db.insert('items', {
      'name': item.name,
      'quantity': item.quantity,
      'status': item.status,
    });
  }

  Future<List<ItemModel>> getItems({String? status}) async {
    final db = await instance.database;
    final result = await db.query(
      'items',
      where: status != null ? 'status = ?' : null,
      whereArgs: status != null ? [status] : null,
    );
    return result.map((json) => ItemModel.fromMap(json)).toList();
  }
}
