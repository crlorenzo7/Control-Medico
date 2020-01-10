import 'dart:io';
import 'dart:isolate';

import 'package:control_medico3/background.dart';
import 'package:control_medico3/middleware/store_dates_middleware.dart';
import 'package:control_medico3/middleware/store_events_middleware.dart';
import 'package:control_medico3/model/CAlarm.dart';
import 'package:control_medico3/reducers/AppReducer.dart';
import 'package:control_medico3/repository/CDosisRepository.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:control_medico3/repository/CTreatmentRepository.dart';
import 'package:flutter/material.dart';
import 'package:control_medico3/ui/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


import 'middleware/store_treatments_middleware.dart';
import 'model/AppState.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';


void main() async {
  final int helloAlarmID = 0;
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
  BackgroundTask(cTreatmentRepository: CTreatmentRepository(),cDosisRepository: CDosisRepository(),cEventRepository: CEventRepository()).init();

}

class MyApp extends StatelessWidget {

  
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware: [...createStoreDatesMiddleware(),...createStoreEventsMiddleware(),...createStoreTreatmentsMiddleware()]
  );
  @override
  Widget build(BuildContext context) {
    
    return StoreProvider(
      store:store,
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control Medico Flutter',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: HomePage(),
      )
    ) ;
  }
}