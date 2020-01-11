import 'package:control_medico3/actions/eventActions.dart';

bool loadingHistoryReducer(bool state,action){
  if(action is LoadHistoryEventsAction){
    return true;
  }
  if(action is HistoryEventsLoadedAction){
    return false;
  }
  if(action is HistoryEventsNotLoadedAction){
    return false;
  }
  return state;

}