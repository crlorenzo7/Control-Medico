import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/actions/treatmentActions.dart';

bool loadingTreatmentsReducer(bool state,action){
  if(action is LoadTreatmentsAction){
    return true;
  }
  if(action is TreatmentsLoadedAction){
    return false;
  }
  if(action is TreatmentsNotLoadedAction){
    return false;
  }
  return state;

}