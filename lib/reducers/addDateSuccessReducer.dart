
import 'package:control_medico3/actions/dateActions.dart';

bool addDateSuccessReducer(bool state,action){
  if(action is DateCreatedAction){
    return true;
  }
  if(action is DateNotCreatedAction){
    return false;
  }
  if(action is DateConfirmCreationAction){
    return false;
  }
  return state;
}