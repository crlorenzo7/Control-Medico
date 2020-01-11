import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/actions/eventActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreEventsMiddleware() {
  final CEventRepository repository=CEventRepository();
  final loadEvents = _createLoadEvents(repository);
  final initHistory = _initHistory(repository);
  final loadHistory = _loadHistory(repository);

  return [
    TypedMiddleware<AppState, LoadEventsAction>(loadEvents),
    TypedMiddleware<AppState, InitHistoryAction>(initHistory),
    TypedMiddleware<AppState, LoadHistoryEventsAction>(loadHistory)
  ];
}


Middleware<AppState> _createLoadEvents(CEventRepository repository) {
  
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.getCEvents().then(
      (events) {
        store.dispatch(
          EventsLoadedAction(events),
        );
      },
    ).catchError((_) => store.dispatch(EventsNotLoadedAction()));

    next(action);
  };
}

Middleware<AppState> _loadHistory(CEventRepository repository) {
  
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.getCEvents(query: action.monthTime).then(
      (events) {
        store.dispatch(
          HistoryEventsLoadedAction(events),
        );
      },
    ).catchError((_) => store.dispatch(HistoryEventsNotLoadedAction()));

    next(action);
  };
}

Middleware<AppState> _initHistory(CEventRepository repository) {
  
  return (Store<AppState> store, action, NextDispatcher next) {
    if(store.state.initialDate==0){
      repository.initHistory().then(
        (initialDate){
          store.dispatch(SetInitialDateHistoryAction(initialDate));
          store.dispatch(LoadHistoryEventsAction(initialDate));
        }
      
      );
    }else{
      store.dispatch(LoadHistoryEventsAction(store.state.initialDate));
    }

    next(action);
  };
}