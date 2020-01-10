import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:control_medico3/actions/eventActions.dart';
import 'package:control_medico3/main.dart';
import 'package:control_medico3/repository/CDosisRepository.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:control_medico3/repository/CTreatmentRepository.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'actions/treatmentActions.dart';
import 'model/AppState.dart';
import 'model/CTreatment.dart';

Future<void> updateAllTreatments() async {
  CTreatmentRepository cTreatmentRepository=CTreatmentRepository();
  CEventRepository cEventRepository=CEventRepository();
  CDosisRepository cDosisRepository=CDosisRepository();

  List<CTreatment> treatments=await cTreatmentRepository.getCTreatments();
  for(int i=0;i<treatments.length;i++){
    if(treatments[i].lastDosisDate!=null){
      int timelapse=(treatments[i].configDosis.frequencyDays*10*24*3600*1000);
      if(((treatments[i].lastDosisDate.toInt()*1000)-(DateTime.now().millisecondsSinceEpoch))<timelapse){
        await cDosisRepository.generateCDosis(treatments[i]);
      }
    }
    
  }
}

class BackgroundTask{
  CTreatmentRepository cTreatmentRepository;
  CEventRepository cEventRepository;
  CDosisRepository cDosisRepository;
  BackgroundTask({this.cTreatmentRepository,this.cDosisRepository,this.cEventRepository});

  Future<void> init() async {
    await updateAllTreatments();
    print("success finish");
  }
}