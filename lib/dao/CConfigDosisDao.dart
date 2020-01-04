import 'package:control_medico3/database/database.dart';
import 'package:control_medico3/model/CConfigDosis.dart';

class CConfigDosisDao{
  final dbProvider=DBProvider.dbProvider;
  final tableName="config_dosis";
  Future<int> createCConfigDosis(CConfigDosis config) async{
    var db=await dbProvider.database;
    var result = db.insert(tableName, config.toMap());
    return result;
  }

  Future<CConfigDosis> getCConfigDosis(int id) async{
    var db=await dbProvider.database;
    var result=await db.query(
      tableName,
      columns:null,
      where:"idTreatment= ?",
      whereArgs:[id]
      );

    CConfigDosis config=result.isEmpty ? null:CConfigDosis.fromMap(result.first);
    return config;
  } 

  Future<int> updateCConfigDosis(CConfigDosis config) async{
    var db=await dbProvider.database;
    var result= await db.update(tableName, config.toMap(),where:"idTreatment= ?",whereArgs: [config.idTreatment]);
    
    return result;
  }

  Future<int> deleteCConfigDosis(int id) async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName, where:"idTreatment= ?",whereArgs: [id]);
    
    return result;
  }

  Future<int> deleteAllCConfigDosis() async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName);
    
    return result;
  }

  
}