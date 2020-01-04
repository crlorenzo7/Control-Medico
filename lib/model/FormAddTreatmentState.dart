import 'CTreatment.dart';

class FormAddTreatmentState{
  final bool isProcessing;
  final bool error;
  final bool success;
  final CTreatment treatment;
  final bool isInyection;

  const FormAddTreatmentState({this.isProcessing=false,this.error=false,this.success=false,this.treatment,this.isInyection=true});

  factory FormAddTreatmentState.loading() => FormAddTreatmentState();

  factory FormAddTreatmentState.fromStore(FormAddTreatmentState state)=>FormAddTreatmentState(
    isProcessing: state.isProcessing,
    error: state.error,
    success: state.success,
    treatment:state.treatment,
    isInyection: state.isInyection
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormAddTreatmentState &&
          isProcessing == other.isProcessing &&
          error == other.error &&
          success == other.success &&
          treatment == other.treatment &&
          isInyection == other.isInyection;

  @override
  String toString() {
    return 'FormDateAddState{isProcessing: $isProcessing,error: $error, success: $success}';
  }
}