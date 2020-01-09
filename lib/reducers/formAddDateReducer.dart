import 'package:control_medico3/model/FormAddDateState.dart';

import 'addDateDateReducer.dart';
import 'addDateProcessingReducer.dart';
import 'addDateSuccessReducer.dart';

FormAddDateState formAddDateReducer(FormAddDateState state, action){
  return FormAddDateState(
    isProcessing: addDateProcessingReducer(state.isProcessing,action),
    success:addDateSuccessReducer(state.success,action),
    date:addDateDateReducer(state.date,action)
  );
}