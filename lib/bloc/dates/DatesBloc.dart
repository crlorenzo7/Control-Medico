import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:bloc/bloc.dart';
import 'DatesEvents.dart';
import 'DatesStates.dart';

class DatesBloc extends Bloc<DatesEvents,DatesStates>{
  final CEventRepository cEventRepository;

  DatesBloc({this.cEventRepository}):assert(cEventRepository!=null);
  @override
  void onTransition(Transition<DatesEvents,DatesStates> transition) {
    super.onTransition(transition);
    print(transition);
  }
  @override
  // TODO: implement initialState
  DatesStates get initialState => DatesUninitializedState();

  @override
  Stream<DatesStates> mapEventToState(DatesEvents event) async*{

    yield DatesFetchingState();
    List<CEvent> events;
    try{
      if(event is OnAppInitialDates){
        Map<String,dynamic> query=new Map();
        query["type"]=CEventType.date.index;
        events= await cEventRepository.getCEvents(columns: null,query: query);
      }
      if(events.length>0){
        yield DatesFetchedState(cDates:events);
      }else{
        yield DatesEmptyState();
      }
    }catch(_){
      yield DatesErrorState();
    }
  }
  
}