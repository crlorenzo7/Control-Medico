import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/CTreatment.dart';

List<CTreatment> treatmentsReducer(List<CTreatment> state,action){
  if(action is TreatmentsLoadedAction){
    return action.treatments;
  }
  return state;
}