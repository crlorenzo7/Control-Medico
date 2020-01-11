import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/actions/eventActions.dart';
import 'package:control_medico3/model/CEvent.dart';

List<CEvent> eventsReducer(List<CEvent> state,action){
  if(action is EventsLoadedAction){
    //print([...state,...action.events]);
    return action.events;
  }
  return state;
}