import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName = "vybe.db";
  static final _databaseVersion = 2;

  //table names
  static final userTable = 'user';

  //columns for userTable
  static final userId = 'user_id';
  static final userName = 'user_name';
  static final userSurname = 'user_surname';
  static final userEmail = 'user_email';
  static final userChosenCat = 'chosen_category';

  //make a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async{
    if(_database != null) return _database;

    //lazily instantiate the db first time it is accessed
    _database =await _initDatabase();
    return _database;
  }

  //this opens the database and creates it if it doesn't exist
  _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate
    );
  }

  //sql code to create the database
  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE $userTable(
        $userId INTEGER PRIMARY KEY,
        $userName TEXT,
        $userSurname TEXT,
        $userEmail TEXT,
        $userChosenCat INTEGER);
        ''');
  }

  ///helper methods for quering the user table
  //inserts a row in the database where each key in the map is column
  Future<int> insertUser(Map<String, dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(userTable, row);
  }

  //All the rows are returned as a list of maps, where each map is a key-value list of columns
  Future<List<Map<String,dynamic>>> queryAllRowsUser() async{
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future<int> queryRowCount() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $userTable'));
  }

  Future<int> queryUserId() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT user_id FROM $userTable'));
  }

  Future<int> queryChosenCategory() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT $userChosenCat FROM $userTable'));
  }

  Future<int> updateUser(Map<String, dynamic> row) async{
    Database db = await instance.database;
    int id = row[userId];
    return await db.update(userTable, row, where: '$userId = ?', whereArgs:[id]);
  }

  Future<int> deleteUser(int id)async{
    Database db = await instance.database;
    return await db.delete(userTable, where: '$userId = ?', whereArgs: [id]);
  }
}