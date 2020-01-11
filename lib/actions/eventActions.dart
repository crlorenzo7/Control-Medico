import 'package:control_medico3/model/CEvent.dart';

class LoadEventsAction{
  List<String> columns;
  Map<String,dynamic> query;
  LoadEventsAction({this.columns,this.query});
}

class LoadHistoryEventsAction{
  Map<String,dynamic> monthTime;
  LoadHistoryEventsAction(int historyTime){monthTime=Map();monthTime["historyTime"]=historyTime;}
}

class SetInitialDateHistoryAction{
  int initialDate;
  SetInitialDateHistoryAction(int initialDate){this.initialDate=initialDate;}
}

class EventsLoadedAction{
  List<CEvent> events;
  EventsLoadedAction(List<CEvent> events){this.events=events;}
}

class HistoryEventsLoadedAction{
  List<CEvent> events;
  HistoryEventsLoadedAction(List<CEvent> events){this.events=events;}
}

class EventsNotLoadedAction{
  
}

class HistoryEventsNotLoadedAction{
  
}

class InitHistoryAction{

}