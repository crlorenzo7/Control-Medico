import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/CTreatment.dart';

CTreatment addTreatmentTreatmentReducer(CTreatment state,action){
  if(action is InitFormAddTreatmentAction){
    return CTreatment();
  }
  if(action is AddTreatmentSubmitStepOne || action is AddTreatmentSubmitStepTwo || action is UpdateTreatmentSubmitStepTwo || action is InitFormEditTreatmentAction){
    return action.treatment;
  }
  if(action is UpdateTreatmentSubmitStepOne){
    Map<String,dynamic> treatment=state.toMap();
    Map<String,dynamic> finalMap={...treatment,...action.formStepOne};
    CConfigDosis config=CConfigDosis.fromMap(state.configDosis.toMap());
    CTreatment cTreatment=CTreatment.fromMap(finalMap);
    cTreatment.configDosis=config;
    return cTreatment;
  }
  return state;
}