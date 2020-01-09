import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/CDate.dart';

CDate addDateDateReducer(CDate state,action){
  if(action is InitFormAddDateAction){
    return CDate();
  }
  if(action is InitFormUpdateDateAction){
    return action.date;
  }
  
  return state;
}