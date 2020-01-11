import 'package:control_medico3/actions/eventActions.dart';

int initialDateReducer(int state,action){
  if(action is SetInitialDateHistoryAction){
    return action.initialDate;
  }
  return state;

}

