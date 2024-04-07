// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:path/path.dart';
import 'package:pharmacy/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/pages/widgets/dialog.dart';

class SqliteStorage {
  static List initScripts = [
    """CREATE TABLE IF NOT EXISTS Drugs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      dosage TEXT,
      consum_cases TEXT,
      prohibit_cases TEXT,
      drug_disorders TEXT,
      food_disorders TEXT,
      consum_roles TEXT,
      descriptions TEXT)""",
    //////////////////////////////////
    """CREATE TABLE IF NOT EXISTS DrugShapes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT)""",
    //////////////////////////////////
    """CREATE TABLE IF NOT EXISTS DrugCategories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT)
    """,
    //////////////////////////////////
    """CREATE TABLE IF NOT EXISTS DrugToCategories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      drug INTEGER,
      category INTEGER,
      FOREIGN KEY (drug) REFERENCES Drugs(id)
      FOREIGN KEY (category) REFERENCES DrugCategories(id))""",
    //////////////////////////////////
    """CREATE TABLE IF NOT EXISTS DrugToShapes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      drug INTEGER,
      shape INTEGER,
      FOREIGN KEY (drug) REFERENCES Drugs(id)
      FOREIGN KEY (shape) REFERENCES DrugShapes(id))""",
  ];

  static List migrationScripts = [
    '''
  DELETE FROM DrugCategories
  WHERE id NOT IN
  (SELECT min(id) FROM DrugCategories
  GROUP BY name);
  DELETE FROM DrugShapes
  WHERE id NOT IN
  (select min(id) FROM DrugShapes
  GROUP BY name);
  CREATE UNIQUE INDEX name ON DrugCategories(name);
  CREATE UNIQUE INDEX name ON DrugShapes(name)''',
  ];

  static Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'Database.db');

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }

    Database db = await openDatabase(
      path,
      version: migrationScripts.length + 1,
      onCreate: (db, version) => initScripts.forEach((element) => db.execute(element)),
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion - 1; i < newVersion - 1; i++) {
          try {
            await db.execute(migrationScripts[i]);
          } catch (e) {
            Utils.logEvent(message: e.toString(), logType: LogType.error);
          }
        }
      },
    );

    return db;
  }

  static Future<int> add({required String tableName, required dynamic instance}) async {
    Database database = await openDB();
    int dbResponse = await database.insert(tableName, instance.toMap());
    await database.close();
    if (dbResponse != 0) {
      Utils.logEvent(
          message: "Instance With Id = $dbResponse inserted to table $tableName!",
          logType: LogType.info);
    } else {
      Utils.logEvent(
          message: "Instance ${instance.runtimeType} not inserted to table $tableName!",
          logType: LogType.error);
    }
    return dbResponse;
  }

  static Future<void> update({required String tableName, required dynamic instance}) async {
    Database database = await openDB();
    int dbResponse = await database
        .update(tableName, instance.toMap(), where: "id = ?", whereArgs: [instance.id]);
    await database.close();
    if (dbResponse != 0) {
      Utils.logEvent(
          message: "Instance With Id = $dbResponse Updated in table $tableName!",
          logType: LogType.info);
    } else {
      Utils.logEvent(message: "Instance not Updated in table $tableName!", logType: LogType.error);
    }
  }

  static Future<List> getAll(
      {required String tableName,
      List<String>? columns,
      int? limit,
      int? offset,
      String? orderBy}) async {
    Database database = await openDB();
    List data = await database.query(
      tableName,
      columns: columns,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    await database.close();
    return data;
  }

  static Future<Batch> createDatabaseBatch() async {
    Database database = await openDB();
    Batch batch = database.batch();
    return batch;
  }

  static Future<List> commitAll({required Batch batch}) async {
    Database database = await openDB();
    List result = await batch.commit();
    await database.close();
    return result;
  }

  static backupDataBase() async {
    final dbFolder = await getDatabasesPath();
    File source1 = File('$dbFolder/Database.db');

    Directory copyTo = Directory("storage/emulated/0/Pharmacy backup");
    if (await copyTo.exists()) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    } else {
      Utils.logEvent(message: "not exist", logType: LogType.error);
      if (await Permission.manageExternalStorage.request().isGranted) {
        await copyTo.create();
      } else {
        Utils.logEvent(message: 'Please give permission', logType: LogType.error);
      }
    }
    String newPath = "${copyTo.path}/pharmacy_database.db";
    await source1.copy(newPath);
    Utils.showToast(
        message: "فایل پایگاه داده در پوشه Pharmacy backup/pharmacy_database.db ذخیره شد.",
        isError: false);
  }

  static restoreDatabase() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'Database.db');
    File database = File(dbPath);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (result.files.single.path!.split('/').last.endsWith(".db")) {
        await openDialog(
            title: "آیا برای بازگردانی به فایل انتخاب شده مطمئن هستید؟",
            onYesTap: () async {
              await database.delete();
              File source = File(result.files.single.path!);
              await source.copy(dbPath);
              Get.back();
            },
            onNoTap: () => Get.back());
      } else {
        Utils.showToast(message: "فایل انتخاب شده نامعتبر است", isError: true);
      }
    } else {
      // User canceled the picker
    }
  }

  static Future<int> getCount({required String tableName}) async {
    Database database = await openDB();
    var result = await database.rawQuery('SELECT COUNT(*) FROM $tableName');
    // await database.close();
    return int.parse(result[0]['COUNT(*)'].toString());
  }
}
