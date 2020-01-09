import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';

List<CEvent> datesReducer(List<CEvent> state,action){
  if(action is DatesLoadedAction){
    return action.dates;
  }
  if(action is DeletedDateAction){
    List<CEvent> dates=state.where((item)=>item.id!=action.dateId).toList();
    return dates;
  }
  /*if(action is DateCreatedAction){
    List<CEvent> events=[...state,action.date];
    events.sort((a,b)=>a.time.compareTo(b.time));
    return events;
  }*/
  
  return state;
}