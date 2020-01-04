
import 'package:bloc/bloc.dart';
import 'package:control_medico3/bloc/treatments/TreatmentsState.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/repository/CTreatmentRepository.dart';
import 'TreatmentsEvents.dart';

class TreatmentsBloc extends Bloc<TreatmentsEvents,TreatmentsState>{
  final CTreatmentRepository cTreatmentRepository;

  TreatmentsBloc({this.cTreatmentRepository}):assert(cTreatmentRepository!=null);
  @override
  void onTransition(Transition<TreatmentsEvents,TreatmentsState> transition) {
    super.onTransition(transition);
    print(transition);
  }
  @override
  // TODO: implement initialState
  TreatmentsState get initialState => TreatmentsUninitializedState();

  @override
  Stream<TreatmentsState> mapEventToState(TreatmentsEvents event) async*{

    yield TreatmentsFetchingState();
    List<CTreatment> treatments;
    try{
      if(event is OnAppInitialTreatment){
        treatments= await cTreatmentRepository.getCTreatments();
      }
      if(treatments.length>0){
        yield TreatmentsFetchedState(cTreatments:treatments);
      }else{
        yield TreatmentsEmptyState();
      }
    }catch(_){
      yield TreatmentsErrorState();
    }
  }
  
}