import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';

bool addTreatmentIsInyectionReducer(bool state,action){
  if(action is AddTreatmentSubmitStepOne){
    if(action.treatment.medicationType==MedicationType.inyeccion_subcutanea){
      return true;
    }
    return false;
  }
  return state;
}