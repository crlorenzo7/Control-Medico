import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';

import 'enumerations/CBodyZone.dart';
import 'enumerations/CTreatmentStatus.dart';

class CTreatment{
  int id;
  String medicationName;
  bool isPermanent;
  MedicationType medicationType=MedicationType.sobres;
  List<int> applicationZones;
  BigInt lastDosisDate;
  int lastDosisBodyZone=CBodyZone.A.index;
  BigInt startDate;
  BigInt endDate;
  CConfigDosis configDosis=CConfigDosis();
  CTreatmentStatus status=CTreatmentStatus.active;

  CTreatment({
    this.id,
    this.medicationName,
    this.isPermanent=false,
    this.medicationType=MedicationType.sobres,
    this.applicationZones,
    this.lastDosisDate,
    this.lastDosisBodyZone=-1,
    this.startDate,
    this.endDate,
    this.status=CTreatmentStatus.active
    });
  

  factory CTreatment.fromMap(Map<String, dynamic> json) => new CTreatment(
        id: json.containsKey("id") ? json["id"]:null,
        medicationName: json.containsKey("medicationName") ? json["medicationName"]:null,
        isPermanent: json.containsKey("isPermanent") ? ((json["isPermanent"])==1 ? true:false):null,
        medicationType: json.containsKey("medicationType") ? MedicationType.values[json["medicationType"]]:null,
        applicationZones: json.containsKey("applicationZones") ? json["applicationZones"].split(",").where((i)=>i!="").map((i)=>int.parse(i)).toList().cast<int>():[],
        lastDosisDate: json.containsKey("lastDosisDate") ? BigInt.from(json["lastDosisDate"]):null,
        lastDosisBodyZone: json.containsKey("lastDosisBodyZone") ? json["lastDosisBodyZone"]:-1,
        startDate: (json.containsKey("startDate") && json["startDate"]!=null) ? BigInt.from(json["startDate"]):null,
        endDate: (json.containsKey("endDate") && json["endDate"]!=null) ? BigInt.from(json["endDate"]):null,
        status: json.containsKey("status") ? CTreatmentStatus.values[json["status"]]:CTreatmentStatus.active
      );

  Map<String, dynamic> toMap() => {
        "id":id,
        "medicationName": medicationName,
        "isPermanent": isPermanent ? 1:0,
        "medicationType": medicationType.index,
        "applicationZones": applicationZones.join(","),
        "lastDosisDate": (lastDosisDate==null) ? 0:lastDosisDate.toInt(),
        "lastDosisBodyZone": lastDosisBodyZone,
        "startDate": startDate!=null ? startDate.toInt():0,
        "endDate": endDate!=null ? endDate.toInt():0,
        "status":status.index
      };
  
  String get getMedicationName => medicationName;
  bool get getIsPermanent => isPermanent;
  MedicationType get getMedicationType => medicationType;
  List<CBodyZone> get getApplicationZones => applicationZones.map((item)=>CBodyZone.values[item]).toList();
  BigInt get getLastDosisDate => lastDosisDate;
  CBodyZone get getLastDosisBodyZone => CBodyZone.values[lastDosisBodyZone];
  BigInt get getStartDate => startDate;
  BigInt get getEndDate => endDate;
  CConfigDosis get getConfigDosis => configDosis;
  int get getId => id;

  CBodyZone getNextApplicationZone(){
    int index=applicationZones.indexOf(lastDosisBodyZone);
    int next=(index+1)%applicationZones.length;
    CBodyZone finalZone=CBodyZone.values[applicationZones[next]];
    lastDosisBodyZone=finalZone.index;
    return finalZone;
  }

  set setId(int id){this.id=id;}
  set setMedicationName(String name){this.medicationName=name;}
  set setIsPermanent(bool isPermanent){this.isPermanent=isPermanent;}
  set setMedicationType(MedicationType medType){this.medicationType=medType;}
  set setApplicationZones(List<int> appZones){this.applicationZones=appZones;}
  set setLastDosisDate(BigInt lastDosisDate){this.lastDosisDate=lastDosisDate;}
  set setLastDosisBodyZone(CBodyZone zone){this.lastDosisBodyZone=zone.index;}
  set setStartDate(BigInt date){this.startDate=date;}
  set setEndDate(BigInt date){this.endDate=date;}
  set setConfigDosis(CConfigDosis config){this.configDosis=config;}

  addApplicationZone(CBodyZone zone){this.applicationZones.add(zone.index);}
  removeApplicationZone(int position){this.applicationZones.removeAt(position);}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CTreatment &&
          medicationName==other.medicationName &&
          isPermanent==other.isPermanent &&
          medicationType==other.medicationType &&
          applicationZones==other.applicationZones &&
          lastDosisBodyZone==other.lastDosisBodyZone &&
          lastDosisDate==other.lastDosisDate &&
          startDate==other.startDate &&
          endDate==other.endDate;
          

}