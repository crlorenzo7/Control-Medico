import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:flutter/cupertino.dart';

abstract class DatesStates{}

class DatesUninitializedState extends DatesStates{}
class DatesFetchingState extends DatesStates{}
class DatesFetchedState extends DatesStates{
  List<CEvent> cDates;
  DatesFetchedState({@required this.cDates});
}
class DatesErrorState extends DatesStates{}
class DatesEmptyState extends DatesStates{}