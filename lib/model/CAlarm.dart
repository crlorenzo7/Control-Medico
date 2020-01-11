import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/Interfaces/Avisos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




void launchAlarm() async{
  if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.control_medico3.messages");
      String data = await methodChannel.invokeMethod("scheduleAlarm");
      debugPrint(data);
    }
  
}

/*Future sendNotification(CEvent cEvent){
    var androidChannel = AndroidNotificationDetails(
      'control-medicoId2227',
      'control-medico2127',
      'channel-description7',
      importance: Importance.Max,
      priority: Priority.Max,
      style: AndroidNotificationStyle.Default,
      sound: 'slow_spring_board',
      playSound: true,
      onlyAlertOnce: false
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    
    plugin.schedule(
        cEvent.id, cEvent.title, cEvent.description, DateTime.now().add(Duration(seconds: 30)), platformChannel,
        payload: cEvent.id.toString(),androidAllowWhileIdle: true);
}*/



class CAlarm implements Avisos{

 
  CAlarm(){
    
  }
  @override
  Future<void> send(CEvent event) async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.control_medico3.messages");
      Map<dynamic,dynamic> arg=new Map<dynamic,dynamic>();
      arg["event"]=event.toMap();
      String data = await methodChannel.invokeMethod("scheduleAlarm",arg);
      debugPrint(data);
    }
    //await AndroidAlarmManager.oneShotAt(DateTime.now().add(Duration(seconds: 30)), 0,launchAlarm,wakeup: true);
    
  }

  @override
  Future<void> cancel(CEvent event) async {
    var methodChannel = MethodChannel("com.control_medico3.messages");
      Map<dynamic,dynamic> arg=new Map<dynamic,dynamic>();
      arg["id"]=event.id;
      String data = await methodChannel.invokeMethod("cancelAlarm",arg);
      debugPrint(data);
  }

}