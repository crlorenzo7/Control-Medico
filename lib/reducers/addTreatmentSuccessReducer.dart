import 'package:control_medico3/actions/treatmentActions.dart';

bool addTreatmentSuccessReducer(bool state,action){
  if(action is TreatmentCreatedAction){
    return true;
  }
  if(action is TreatmentUpdatedAction){
    return true;
  }
  if(action is TreatmentNotCreatedAction){
    return false;
  }
  if(action is TreatmentConfirmCreationAction){
    return false;
  }
  if(action is DeletedTreatmentAction){
    return false;
  }
  if(action is NotDeletedTreatmentAction){
    return false;
  }
  return state;
}