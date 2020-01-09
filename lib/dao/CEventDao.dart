import 'package:control_medico3/database/database.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CDosis.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';

class CEventDao{
  final dbProvider=DBProvider.dbProvider;
  final tableName="events";
  Future<int> createCEvent(CEvent event) async{
    var db=await dbProvider.database;
    var result = await db.insert(tableName,event.toMap());
    return result;
  }

  Future<List<CEvent>> getCEvents(List<String> columns,Map<String,dynamic> query) async{
    var db=await dbProvider.database;
  
    int nowTime=(DateTime.now().millisecondsSinceEpoch~/1000);
    String whereClause="time >= ? ";
    String sortClause="time asc";
    List<dynamic> whereArgs=[nowTime];

    if(query!=null){
      query.forEach((k,v){
        switch(k){
          case "title":{
            whereClause+=" and title LIKE ?";
            whereArgs.add(v);
          } break;
          case "idTreatment":{
            whereClause+=" and idTreatment=?";
            whereArgs.add(v);
          }break;
          case "type":{
            whereClause+=" and type=?";
            whereArgs.add(v);
          }break;
        }
      });
    }

    var results=await db.query(
      tableName,
      columns:columns,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: sortClause
      );
    
    List<CEvent> cEvents=results.isEmpty ? []:results.map((item){
      print(item["time"]);
      if(item["type"]==CEventType.alarm.index){
        return CDosis.fromMap(item);
      }
      return CDate.fromMap(item);
    }).toList();
    return cEvents;
  }

  Future<CEvent> getCEvent(int id) async{
    var db=await dbProvider.database;
    var result=await db.query(
      tableName,
      columns:null,
      where:"id= ?",
      whereArgs:[id]
      );

    if(result.isEmpty){
      return null;
    }else{
      if(result.first["eventType"]==CEventType.alarm.index){
        return CDosis.fromMap(result.first);
      }
      return CDate.fromMap(result.first);
    }
  } 

  Future<int> updateCEvent(CEvent cEvent) async{
    var db=await dbProvider.database;
    var result= await db.update(tableName, cEvent.toMap(),where:"id= ?",whereArgs: [cEvent.id]);
    
    return result;
  }

  Future<int> deleteCEvent(int id) async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName, where:"id= ?",whereArgs: [id]);
    
    return result;
  }

  Future<int> deleteAllCEvents() async{
    var db=await dbProvider.database;
    var result= await db.delete(tableName);
    
    return result;
  }
}