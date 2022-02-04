import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "saksham.db";
  static final _databaseVersion = 1;

  static final table = 'nutrition_records';

  static final columnId = '_id';
  static final columnNutritionFoodItemName = 'nutritionFoodItemName';
  static final columnNutritionFoodItemCalories = 'nutritionFoodItemCalories';
  static final columnNutritionFoodConsumedQuantity =
      'nutritionFoodConsumedQuantity';
  static final columnNutritionFoodConsumedTag = 'nutritionFoodConsumedTag';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onUpgrade: _upgrade, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNutritionFoodItemName TEXT,
            $columnNutritionFoodItemCalories INTEGER,
            $columnNutritionFoodConsumedQuantity INTEGER,
            $columnNutritionFoodConsumedTag TEXT
          )
          ''');
  }

  Future _upgrade(Database db, int oldVersion, int newVersion) async {
    /* await db.execute("ALTER TABLE " +
        table +
        " ADD COLUMN " +
        columnUuid +
        " TEXT default null");*/
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    final Database db = await instance.database;
    return db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final Database db = await instance.database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> querySelectFirstRow() async {
    final Database db = await instance.database;
    return db.rawQuery('SELECT * FROM $table LIMIT 1');
  }

  //ORDER BY ROWID ASC

  Future<List<Map<String, dynamic>>> querySelectWhereFoodName(
      String foodName) async {
    final Database db = await instance.database;
    return db.rawQuery(
        'SELECT * FROM $table WHERE $columnNutritionFoodItemName=?',
        [foodName]);
  }

  Future<List<Map<String, dynamic>>> querySelectOrderByConsumedQuantity(
      String nutritionType) async {
    final Database db = await instance.database;
    return db.rawQuery(
        'SELECT * FROM $table WHERE $columnNutritionFoodConsumedTag = ? ORDER BY $columnNutritionFoodConsumedQuantity DESC',
        [nutritionType]);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    final Database db = await instance.database;
    final String foodItemName = row[columnNutritionFoodItemName];
    return db.update(table, row,
        where: '$columnNutritionFoodItemName = ?', whereArgs: [foodItemName]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    final Database db = await instance.database;
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
