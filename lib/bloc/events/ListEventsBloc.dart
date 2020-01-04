import "package:control_medico3/bloc/events/ListEventsEvents.dart";
import 'package:control_medico3/bloc/events/ListEventsState.dart';
import 'package:bloc/bloc.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/repository/CEventRepository.dart';

class ListEventsBloc extends Bloc<ListEventsEvents,ListEventsState>{
  final CEventRepository cEventRepository;

  ListEventsBloc({this.cEventRepository}):assert(cEventRepository!=null);
  @override
  void onTransition(Transition<ListEventsEvents,ListEventsState> transition) {
    super.onTransition(transition);
    print(transition);
  }
  @override
  // TODO: implement initialState
  ListEventsState get initialState => ListEventsUninitializedState();

  @override
  Stream<ListEventsState> mapEventToState(ListEventsEvents event) async*{

    yield ListEventsFetchingState();
    List<CEvent> events;
    try{
      if(event is OnAppInitialEvent){
        events= await cEventRepository.getCEvents(columns: null,query: null);
      }
      if(events.length>0){
        yield ListEventsFetchedState(cEvents:events);
      }else{
        yield ListEventsEmptyState();
      }
    }catch(_){
      yield ListEventsErrorState();
    }
  }
  
}