
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
  if(action is DeleteDateAction){
    return true;
  }
  if(action is DeletedDateAction){
    return false;
  }
  if(action is NotDeletedDateAction){
    return false;
  }
  if(action is DateUpdatedAction){
    return false;
  }
  if(action is DateNotUpdatedAction){
    return false;
  }

  return state;
}