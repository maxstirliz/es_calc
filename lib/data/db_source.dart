import 'package:es_calc/data/shopping_list_data_source.dart';
import 'package:es_calc/models/shopping_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const id = 'id';
const uuid = 'uuid';
const name = 'name';
const price = 'price';
const quantity = 'quantity';
const isBought = 'bought';
const dbName = 'es_calc.db';
const shoppingListTable = 'shopping_list';

class DatabaseSource implements ShoppingListDataSource {

  Future<Database> _getDatabase() async {
    return openDatabase(
      version: 1,
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $shoppingListTable($id INTEGER PRIMARY KEY, $uuid TEXT, $name TEXT, $price REAL, $quantity REAL, $isBought INTEGER)',
        );
      },
    );
  }

  @override
  Future<List<ShoppingItem>> getItems() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      shoppingListTable,
      orderBy: '$isBought ASC, $name ASC, $uuid ASC',
    );

    return List.generate(
        maps.length, (index) => ShoppingItem().fromMap(maps[index]));
  }

  @override
  Future<List<ShoppingItem>> addItem(ShoppingItem item) async {
    final db = await _getDatabase();
    await db.insert(
      shoppingListTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return getItems();
  }

  @override
  Future<List<ShoppingItem>> updateItem(ShoppingItem item) async {
    final db = await _getDatabase();
    await db.update(
      shoppingListTable,
      item.toMap(),
      where: 'uuid = ?',
      whereArgs: [item.uuid],
    );
    return getItems();
  }

  @override
  Future<List<ShoppingItem>> deleteItem(String itemUuid) async {
    final db = await _getDatabase();

    await db.delete(
      shoppingListTable,
      where: 'uuid = ?',
      whereArgs: [itemUuid],
    );

    return getItems();
  }
}
