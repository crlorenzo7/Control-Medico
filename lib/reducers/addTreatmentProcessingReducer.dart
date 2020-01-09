
import 'package:control_medico3/actions/treatmentActions.dart';

bool addTreatmentProcessingReducer(bool state,action){
  if(action is AddTreatmentAction){
    return true;
  }
  if(action is TreatmentCreatedAction){
    return false;
  }
  if(action is TreatmentNotCreatedAction){
    return false;
  }
  if(action is TreatmentUpdatedAction){
    return false;
  }
  if(action is TreatmentNotUpdatedAction){
    return false;
  }
  if(action is DeleteTreatmentAction){
    return true;
  }
  if(action is DeletedTreatmentAction){
    return false;
  }
  if(action is NotDeletedTreatmentAction){
    return false;
  }
  return state;
}