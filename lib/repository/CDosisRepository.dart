import 'package:control_medico3/dao/CEventDao.dart';
import 'package:control_medico3/model/CAlarm.dart';
import 'package:control_medico3/model/CDosis.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/dao/CConfigDosisDao.dart';
import 'package:control_medico3/dao/CTreatmentDao.dart';
import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/conts.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';

class CDosisRepository{
  final CEventDao eventDao=CEventDao();
  final CTreatmentDao treatmentDao=CTreatmentDao();
  final CConfigDosisDao configDosisDao=CConfigDosisDao();
  
  
  
  CDosisRepository();

  Future<void> generateCDosis(CTreatment cTreatment) async{
    int startInterval=0;
    int endInterval=0;
    DateTime actualDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    if(cTreatment.isPermanent){
      startInterval=cTreatment.lastDosisDate.toInt();
      endInterval=startInterval+(INIT_INTERVAL_LENGTH*24*3600);
    }else{
      startInterval=cTreatment.startDate.toInt()>(actualDate.millisecondsSinceEpoch~/1000) ? cTreatment.startDate.toInt():(actualDate.millisecondsSinceEpoch~/1000);
      endInterval=(startInterval+(INIT_INTERVAL_LENGTH*24*3600)<cTreatment.endDate.toInt()) ? startInterval+(INIT_INTERVAL_LENGTH*24*3600):cTreatment.endDate.toInt();
    }

    int initDay=startInterval;
    while(initDay<=endInterval){
      if(initDay>(actualDate.millisecondsSinceEpoch~/1000)){
        for(int i=0;i<cTreatment.configDosis.dosisTime.length;i++){
          CDosis cDosis=CDosis(medicationType: cTreatment.medicationType);
          if(cTreatment.medicationType==MedicationType.inyeccion_subcutanea){
            if(initDay==startInterval){
              cDosis.applicationZone=cTreatment.getLastDosisBodyZone;
            }else{
              cDosis.applicationZone=cTreatment.getNextApplicationZone();
            }
          }
          cDosis.setDay=DateTime.fromMillisecondsSinceEpoch(initDay*1000);
          cDosis.time=BigInt.from(cDosis.day.toInt()+cTreatment.configDosis.dosisTime[i]);
          cDosis.idTreatment=cTreatment.id;
          cDosis.type=CEventType.alarm;
          cDosis.title="Dosis "+cTreatment.medicationName;

          int idEvent=await eventDao.createCEvent(cDosis);
          cDosis.id=idEvent;
          CAlarm().send(cDosis);
        }
      }
      initDay+=(cTreatment.configDosis.frequencyDays*24*3600);
      
    }
    if(cTreatment.medicationType==MedicationType.inyeccion_subcutanea && cTreatment.isPermanent){
      cTreatment.getNextApplicationZone();
      cTreatment.lastDosisDate=BigInt.from(initDay);

    }else{
      cTreatment.lastDosisDate=BigInt.from(initDay+(cTreatment.configDosis.frequencyDays*24*3600));
    }
    await treatmentDao.updateCTreatment(cTreatment);

    

  }

  Future<bool> deleteAllDosisTreatment(CTreatment treatment) async{
    Map<String,dynamic> query=Map();
    query["idTreatment"]=treatment.id;
    List<CEvent> dosisList=await eventDao.getCEvents(null,query);

    for(int i=0;i<dosisList.length;i++){
      CEvent dosis=dosisList[i];
      await eventDao.deleteCEvent(dosis.id);
      CAlarm().cancel(dosis);
    }
    return true;
  }
  
}