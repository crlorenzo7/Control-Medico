import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/CTreatment.dart';

CTreatment addTreatmentTreatmentReducer(CTreatment state,action){
  if(action is InitFormAddTreatmentAction){
    return CTreatment();
  }
  if(action is AddTreatmentSubmitStepOne || action is AddTreatmentSubmitStepTwo){
    return action.treatment;
  }
  return state;
}