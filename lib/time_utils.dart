import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeUtils{
  TimeUtils();

  Future<int> selectTime(BuildContext context,int time) async {
    TimeOfDay current=time!=null ? TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(time*1000)):TimeOfDay(hour: 0,minute: 0);
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: current,
      context: context,
    );
    
    return selectedTime!=null ? (selectedTime.hour*3600+selectedTime.minute*60):null;
    
    
  }

  Future<int> selectDate(BuildContext context,int date) async {
    DateTime current=date!=null ? DateTime.fromMillisecondsSinceEpoch(date*1000):null;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: current ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != current){

      return (picked.millisecondsSinceEpoch~/1000);
      
    }
    return null;
  }
}