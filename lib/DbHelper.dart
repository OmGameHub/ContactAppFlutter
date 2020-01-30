import 'package:contact_app_sqflite/MyContact.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DbHelper
{
  static DbHelper _dbHelper;
  static Database _database;
  
  final String myContactDB = 'mycontact.db';
  final String myContactTable = 'mycontact_table';
  final String colId = '_id';
  final String colName = 'name';
  final String colNumber = 'number';
  final String colEmail = 'email';

  DbHelper._createInstance();

  factory DbHelper()
  {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }

    return _dbHelper;
  }

  Future<Database> get database async 
  {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + myContactDB;

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDB);

    return notesDatabase;
  }

  void _createDB(Database db, int newVersion) async
  {
    await db.execute(
      'CREATE TABLE $myContactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colNumber, TEXT, $colEmail TEXT)'
    );
  }

  Future<List<Map<String, dynamic>>> getMyContactsMapList() async
  {
    Database db = await this.database;

    var result = await db.query(myContactTable, orderBy: '$colName ASC');
    return result;
  }

  Future<int> insertMyContact(MyContact contact) async
  {
    Database db = await this.database;

    var result = await db.insert(
      myContactTable, 
      contact.toMap()
    );
    return result;
  }

  Future<int> updateMyContact(MyContact myContact) async
  {
    Database db = await this.database;

    var result = await db.update(
      myContactTable, 
      myContact.toMap(), 
      where: '$colId = ?',
      whereArgs: [myContact.id]
    );
    return result;
  }

  Future<int> deleteMyContact(int id) async
  {
    Database db = await this.database;

    var result = await db.delete(
      myContactTable, 
      where: '$colId = ?',
      whereArgs: [id]
    );
    return result;
  }

  Future<int> getCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $myContactTable');
    debugPrint("x: $x");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<MyContact>> getMyContactList() async
  {
    var mycontactMapList = await getMyContactsMapList();
    int count = mycontactMapList.length;

    List<MyContact> mycontactList = List();
    for (var i = 0; i < count; i++) {
      mycontactList.add(MyContact.fromMapObject(mycontactMapList[i]));
    }

    return mycontactList;
  }
}