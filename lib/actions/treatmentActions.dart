import 'package:control_medico3/model/CTreatment.dart';

class LoadTreatmentsAction{
  List<String> columns;
  Map<String,dynamic> query;
  LoadTreatmentsAction({this.columns,this.query});
}

class TreatmentsLoadedAction{
  List<CTreatment> treatments;
  TreatmentsLoadedAction(List<CTreatment> treatments){this.treatments=treatments;}
}

class TreatmentsNotLoadedAction{}

class AddTreatmentAction{
  CTreatment treatment;
  AddTreatmentAction(CTreatment treatment){this.treatment=treatment;}
}

class TreatmentCreatedAction{
  CTreatment treatment;
  TreatmentCreatedAction(CTreatment treatment){this.treatment=treatment;}
}

class TreatmentNotCreatedAction{}

class TreatmentConfirmCreationAction{}

class SetTreatmentInyectionAction{
  bool isInyection;
  SetTreatmentInyectionAction(bool isInyection){this.isInyection=isInyection;}
}

class AddTreatmentSubmitStepOne{
  CTreatment treatment;
  AddTreatmentSubmitStepOne(CTreatment treatment){this.treatment=treatment;}
}

class AddTreatmentSubmitStepTwo{
  CTreatment treatment;
  AddTreatmentSubmitStepTwo(CTreatment treatment){this.treatment=treatment;}
}

class InitFormAddTreatmentAction{
  
}