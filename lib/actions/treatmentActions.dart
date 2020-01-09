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

class UpdateTreatmentAction{
  CTreatment treatment;
  UpdateTreatmentAction(CTreatment treatment){this.treatment=treatment;}
}

class TreatmentCreatedAction{
  CTreatment treatment;
  TreatmentCreatedAction(CTreatment treatment){this.treatment=treatment;}
}

class TreatmentUpdatedAction{
  CTreatment treatment;
  TreatmentUpdatedAction(CTreatment treatment){this.treatment=treatment;}
}

class TreatmentNotCreatedAction{}

class TreatmentNotUpdatedAction{}

class TreatmentConfirmCreationAction{}

class SetTreatmentInyectionAction{
  bool isInyection;
  SetTreatmentInyectionAction(bool isInyection){this.isInyection=isInyection;}
}

class AddTreatmentSubmitStepOne{
  CTreatment treatment;
  AddTreatmentSubmitStepOne(CTreatment treatment){this.treatment=treatment;}
}
class UpdateTreatmentSubmitStepOne{
  Map<String,dynamic> formStepOne;
  UpdateTreatmentSubmitStepOne(Map<String,dynamic> formStepOne){this.formStepOne=formStepOne;}
}

class AddTreatmentSubmitStepTwo{
  CTreatment treatment;
  AddTreatmentSubmitStepTwo(CTreatment treatment){this.treatment=treatment;}
}

class UpdateTreatmentSubmitStepTwo{
  CTreatment treatment;
  UpdateTreatmentSubmitStepTwo(CTreatment treatment){this.treatment=treatment;}
}

class InitFormAddTreatmentAction{
  
}

class DeleteTreatmentAction{
  CTreatment treatment;
  DeleteTreatmentAction(CTreatment treatment){this.treatment=treatment;}
}

class DeletedTreatmentAction{
  int treatmentId;
  DeletedTreatmentAction(int treatmentId){this.treatmentId=treatmentId;}
}

class NotDeletedTreatmentAction{}

class InitFormEditTreatmentAction{
  CTreatment treatment;
  InitFormEditTreatmentAction(CTreatment treatment){this.treatment=treatment;}
}