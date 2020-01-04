import 'package:control_medico3/model/CLocation.dart';
import 'package:flutter/material.dart';

import 'enumerations/CEventState.dart';
import 'enumerations/CEventType.dart';

class CEvent{
  int id;
  int idTreatment;
  BigInt day;
  BigInt time;
  String title;
  String description;
  CEventType type;
  CEventState eventState;

  CEvent({this.id,this.idTreatment=0,this.day,this.time,this.title,this.description="",this.type,this.eventState=CEventState.pending});

  factory CEvent.fromMap(Map<String, dynamic> json) => new CEvent(
        id:json["id"],
        idTreatment:json["idTreatment"],
        day: BigInt.from(json["day"]),
        time:BigInt.from(json["time"]),
        title: json["title"],
        description: json["description"],
        type: CEventType.values[json["type"]],
        eventState: CEventState.values[json["eventState"]]
      );
  

  Map<String, dynamic> toMap() => {
        "id":id,
        "idTreatment":idTreatment,
        "day": day.toInt(),
        "time":time.toInt(),
        "title": title,
        "type": type.index,
        "description":description,
        "eventState":eventState.index
      };

  void loadMap(Map<String, dynamic> json){
     
        if(json.containsKey("id")){
          id=json["id"];
        }
        if(json.containsKey("idTreatment")){
          idTreatment=json["idTreatment"];
        }
        if(json.containsKey("day")){
          day= BigInt.from(json["day"]);
        }
        if(json.containsKey("time")){
          time=BigInt.from(json["time"]);
        }
        if(json.containsKey("title")){
          title= json["title"];
        }
        if(json.containsKey("description")){
          description= json["description"];
        }
        if(json.containsKey("type")){
          type= CEventType.values[json["type"]];
        }
        if(json.containsKey("eventState")){
          eventState= CEventState.values[json["eventState"]];
        }

  }
  
  set setId(int id){this.id=id;}
  set setTime(DateTime time){
    this.time=BigInt.from(time.millisecondsSinceEpoch~/1000);
  }
  set setIdTreatment(int id){this.idTreatment=id;}
  set setDay(DateTime day){
    var time=BigInt.from(day.millisecondsSinceEpoch~/1000);
    var dayOffsetSeconds= time - BigInt.from(((day.hour*3600)+(day.minute*60)+(day.second)));
    this.day=dayOffsetSeconds;
  }

  set setTitle(String title){this.title=title;}
  set setDescription(String description){this.description=description;}
  set setType(CEventType et){this.type=et;}
  set setEventState(CEventState es){this.eventState=es;}

  get getId => id;
  get getIdTreatment => idTreatment;
  get getDay => DateTime.fromMillisecondsSinceEpoch((day.toInt()*1000));
  get getTime => DateTime.fromMillisecondsSinceEpoch((time.toInt()*1000));
  get getTitle => title;
  get getDescription => description;
  get getType => type;
  get getEventState => eventState;
}





