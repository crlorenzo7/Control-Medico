import 'package:control_medico3/actions/eventActions.dart';

bool loadingEventsReducer(bool state,action){
  if(action is LoadEventsAction){
    return true;
  }
  if(action is EventsLoadedAction){
    return false;
  }
  if(action is EventsNotLoadedAction){
    return false;
  }
  return state;

}