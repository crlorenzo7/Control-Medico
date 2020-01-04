import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/Interfaces/Avisos.dart';
import 'package:control_medico3/model/enumerations/CBodyZone.dart';

import 'enumerations/MedicationType.dart';

class CDosis extends CEvent{
  Avisos recordatorio;
  int quantity;
  MedicationType medicationType;
  CBodyZone applicationZone;

  CDosis({this.recordatorio,this.quantity=0,this.medicationType,this.applicationZone=CBodyZone.A});

  factory CDosis.fromMap(Map<String, dynamic> json){
    CDosis dosis= new CDosis(
                        quantity:json["quantity"],
                        medicationType:MedicationType.values[json["medicationType"]],
                      );
    if(json.containsKey("applicationZone")){
      dosis.applicationZone=CBodyZone.values[json["applicationZone"]];
    }
    dosis.loadMap(json);
    return dosis;
  }

  Map<String, dynamic> toMap() => {}..addAll(super.toMap())..addAll({
    "quantity":quantity,
    "medicationType":medicationType.index,
    "applicationZone":applicationZone.index
  });
        
  set setApplicationZone(CBodyZone cBodyZone){this.applicationZone=cBodyZone;}
  set setRecordatorio(Avisos recordatorio){this.recordatorio=recordatorio;}
  set setQuantity(int quantity){this.quantity=quantity;}
  set setMedicationType(MedicationType mt){this.medicationType=mt;}

  Avisos get getRecordatorio => recordatorio;
  int get getQuantity => quantity;
  MedicationType get getMedicationType => medicationType;
  CBodyZone get getApplicationZone => applicationZone;
}
