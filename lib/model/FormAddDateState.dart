import 'CDate.dart';

class FormAddDateState{
  final bool isProcessing;
  final bool error;
  final bool success;
  final CDate date;

  const FormAddDateState({this.isProcessing=false,this.error=false,this.success=false,this.date});

  factory FormAddDateState.loading() => FormAddDateState();

  factory FormAddDateState.fromStore(FormAddDateState state)=>FormAddDateState(
    isProcessing: state.isProcessing,
    error: state.error,
    success: state.success,
    date:CDate.fromMap(state.date.toMap())
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormAddDateState &&
          isProcessing == other.isProcessing &&
          error == other.error &&
          success == other.success;

  @override
  String toString() {
    return 'FormDateAddState{isProcessing: $isProcessing,error: $error, success: $success}';
  }
}