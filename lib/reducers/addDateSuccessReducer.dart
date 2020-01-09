
import 'package:control_medico3/actions/dateActions.dart';

bool addDateSuccessReducer(bool state,action){
  if(action is DateCreatedAction){
    return true;
  }
  if(action is DateUpdatedAction){
    return true;
  }
  if(action is DateNotCreatedAction){
    return false;
  }
  if(action is DateConfirmCreationAction){
    return false;
  }
  if(action is DeletedDateAction){
    return false;
  }
  if(action is NotDeletedDateAction){
    return false;
  }
  return state;
}