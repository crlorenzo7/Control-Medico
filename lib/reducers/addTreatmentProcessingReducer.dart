
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
  return state;
}