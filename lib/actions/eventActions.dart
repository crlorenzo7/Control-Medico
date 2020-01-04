import 'package:control_medico3/model/CEvent.dart';

class LoadEventsAction{
  List<String> columns;
  Map<String,dynamic> query;
  LoadEventsAction({this.columns,this.query});
}

class EventsLoadedAction{
  List<CEvent> events;
  EventsLoadedAction(List<CEvent> events){this.events=events;}
}

class EventsNotLoadedAction{
  
}