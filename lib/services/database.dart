import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'tasksDatabase3.db';
  static final _dbVersion = 1;
  static final _tableName = "tasksTable";

  static final columnId = "_id";
  static final columnTaskDescription = "taskDescription";
  static final columnTaskTime = "taskTime";
  static final columnIsTaskCompleted = "isTaskCompleted";
  static final columnTaskCategory = "taskCategory";
  static final columnTaskIsAlarmSetted = "taskIsAlarmSetted";

  static final _alarmTableName = "alarmsTable";

  static final alarmColumnId = "_id";
  static final alarmColumnkDescription = "alarmDescription";
  static final alarmColumnTime = "alarmTime";

  //singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute(''' 
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY, 
      $columnTaskDescription TEXT NOT NULL,
      $columnTaskTime INTEGER, 
      $columnIsTaskCompleted INTEGER,
      $columnTaskCategory TEXT NOT NULL,
      $columnTaskIsAlarmSetted TEXT NOT NULL)
      ''');

    db.execute(''' 
      CREATE TABLE $_alarmTableName(
      $alarmColumnId INTEGER PRIMARY KEY, 
      $alarmColumnkDescription TEXT NOT NULL,
      $alarmColumnTime INTEGER)
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> insertAlarm(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_alarmTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllAlarm() async {
    Database db = await instance.database;
    return await db.query(_alarmTableName);
  }

  Future<int> updateAlarm(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[alarmColumnId];
    return await db.update(_alarmTableName, row,
        where: '$alarmColumnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_alarmTableName, where: '$alarmColumnId = ?', whereArgs: [id]);
  }
}
