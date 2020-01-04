import 'package:control_medico3/actions/dateActions.dart';

bool loadingDatesReducer(bool state,action){
  if(action is LoadDatesAction){
    return true;
  }
  if(action is DatesLoadedAction){
    return false;
  }
  if(action is DatesNotLoadedAction){
    return false;
  }
  return state;

}