
import 'package:control_medico3/actions/dateActions.dart';

bool addDateProcessingReducer(bool state,action){
  if(action is AddDateAction){
    return true;
  }
  if(action is DateCreatedAction){
    return false;
  }
  if(action is DateNotCreatedAction){
    return false;
  }
  return state;
}