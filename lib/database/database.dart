import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

final eventsTable= "Events";
final treatmentsTable="Treatments";

class DBProvider{
  static final DBProvider dbProvider = DBProvider();
  static final DB_NAME = "control_medico.db";
  static final DB_INIT_FILE = "initDB.txt";
  Database _db;

  Future<Database> get database async{
    if(_db!=null){
      return _db;
    }
    _db=await createDB();
    return _db;
  }

  createDB() async{
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path,DB_NAME);
    var db = await openDatabase(path,version:1,onCreate:initDB,onUpgrade:onUpgrade);
    return db;
  }

  void initDB(Database db,int version) async{
    String content = await rootBundle.loadString('assets/initDB.txt');

    List<String> tables=content.split("\$\n");
    for(String table in tables){
      if(table!=""){
        await db.execute(table);
      }
    }
    db.execute("INSERT INTO settings(initialDate) values(${(DateTime.now().millisecondsSinceEpoch~/1000)})");
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }


}