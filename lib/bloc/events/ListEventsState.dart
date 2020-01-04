import 'package:control_medico3/model/CEvent.dart';
import 'package:flutter/cupertino.dart';

abstract class ListEventsState{}

class ListEventsUninitializedState extends ListEventsState{}
class ListEventsFetchingState extends ListEventsState{}
class ListEventsFetchedState extends ListEventsState{
  List<CEvent> cEvents;
  ListEventsFetchedState({@required this.cEvents});
}
class ListEventsErrorState extends ListEventsState{}
class ListEventsEmptyState extends ListEventsState{}