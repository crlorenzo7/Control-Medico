import 'dart:convert';

import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/CLocation.dart';
import 'package:control_medico3/model/Interfaces/Avisos.dart';


class CDate extends CEvent{
  Avisos recordatorio;
  CLocation place;

  /*CDate(Map<String, dynamic> mjson){
    if(mjson.containsKey("place")){
      if(mjson["place"]!=""){
        this.place=json.decode(mjson["place"]);
      }
    }
    super.loadMap(mjson);
  }*/

  CDate():super();

  factory CDate.fromMap(Map<String, dynamic> mjson){
    CDate date=new CDate();
    if(mjson.containsKey("place")){
      if(mjson["place"]!=""){
        date.place=json.decode(mjson["place"]);
      }
    }
    date.loadMap(mjson);
    return date;
  }

  Map<String, dynamic> toMap() =>{}..addAll(super.toMap())..addAll({
        
          "place":place==null ? "":json.encode(place.toMap())
        
      });

  set setRecordatorio(Avisos recordatorio){this.recordatorio=recordatorio;}
  set setPlace(CLocation place){this.place=place;}
  Avisos get getRecordatorio => recordatorio;
  CLocation get getPlace => place;
}

