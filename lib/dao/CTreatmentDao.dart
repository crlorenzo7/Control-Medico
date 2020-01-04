import 'package:control_medico3/database/database.dart';
import 'package:control_medico3/model/CTreatment.dart';

class CTreatmentDao{
  final dbProvider=DBProvider.dbProvider;
  final tableName="treatments";
  Future<int> createCTreatment(CTreatment treatment) async{
    var db=await dbProvider.database;
    var result = db.insert(tableName, treatment.toMap());
    return result;
  }

  Future<List<CTreatment>> getCTreatments({List<String> columns,Map<String,dynamic> query}) async{
    var db=await dbProvider.database;

    String whereClause="";
    List<String> whereArgs=[];
    if(query!=null){
      query.forEach((k,v){
        switch(k){
          case "medicationName":{
            if(whereClause==""){
              whereClause+="medicationName LIKE ?";
            }else{
              whereClause+=" and medicationName LIKE ?";
            }
            whereArgs.add(v);
          } break;
        }
      });
    }else{
      whereClause=null;
    }

    var results=await db.query(
      tableName,
      columns:columns,
      where: whereClause,
      whereArgs: whereArgs
      );
    
    List<CTreatment> cTreatment=results.isEmpty ? []:results.map((item)=>CTreatment.fromMap(item)).toList();
    return cTreatment;
  }

  Future<CTreatment> getCTreatment(int id) async{
    var db=await dbProvider.database;
    var result=await db.query(
      tableName,
      columns:null,
      where:"id= ?",
      whereArgs:[id]
      );

    CTreatment cTreatment = result.isEmpty ? null:CTreatment.fromMap(result.first);
    return cTreatment;

  } 

  Future<int> updateCTreatment(CTreatment cTreatment) async{
    var db=await dbProvider.database;
    var result= await db.update(tableName, cTreatment.toMap(),where:"id= ?",whereArgs: [cTreatment.id]);
    
    return result;
  }

  Future<int> deleteCTreatment(int id) async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName, where:"id= ?",whereArgs: [id]);
    
    return result;
  }

  Future<int> deleteAllCTreatment() async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName);
    
    return result;
  }
}