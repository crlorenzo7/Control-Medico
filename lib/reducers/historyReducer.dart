import 'package:control_medico3/actions/eventActions.dart';
import 'package:control_medico3/model/CEvent.dart';

List<CEvent> historyReducer(List<CEvent> state,action){
  if(action is HistoryEventsLoadedAction){

    return action.events;
  }
  return state;
}