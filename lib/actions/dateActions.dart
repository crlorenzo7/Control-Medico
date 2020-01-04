import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';

class LoadDatesAction{
  List<String> columns;
  Map<String,dynamic> query;
  LoadDatesAction({this.columns,this.query}){
    if(this.query==null){
      this.query=new Map();
    }
    query["type"]=1;
  }
}

class DatesLoadedAction{
  List<CEvent> dates;
  DatesLoadedAction(List<CEvent> dates){this.dates=dates;}
}

class DatesNotLoadedAction{}

class AddDateAction{
  CDate date;
  AddDateAction(CDate date){this.date=date;}
}

class DateCreatedAction{
  CEvent date;
  DateCreatedAction(CEvent date){this.date=date;}
}

class DateNotCreatedAction{}

class DateConfirmCreationAction{}