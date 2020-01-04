
import 'package:control_medico3/model/CTreatment.dart';
import 'package:flutter/cupertino.dart';

abstract class TreatmentsState{}

class TreatmentsUninitializedState extends TreatmentsState{}
class TreatmentsFetchingState extends TreatmentsState{}
class TreatmentsFetchedState extends TreatmentsState{
  List<CTreatment> cTreatments;
  TreatmentsFetchedState({@required this.cTreatments});
}
class TreatmentsErrorState extends TreatmentsState{}
class TreatmentsEmptyState extends TreatmentsState{}