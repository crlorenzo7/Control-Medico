import 'package:control_medico3/model/FormAddTreatmentState.dart';

import 'addTreatmentIsInyectionReducer.dart';
import 'addTreatmentProcessingReducer.dart';
import 'addTreatmentSuccessReducer.dart';
import 'addTreatmentTreatmentReducer.dart';

FormAddTreatmentState formAddTreatmentReducer(FormAddTreatmentState state, action){
  return FormAddTreatmentState(
    isProcessing: addTreatmentProcessingReducer(state.isProcessing,action),
    success:addTreatmentSuccessReducer(state.success,action),
    isInyection:addTreatmentIsInyectionReducer(state.isInyection,action),
    treatment: addTreatmentTreatmentReducer(state.treatment,action)
  );
}