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

  return [
    TypedMiddleware<AppState, LoadEventsAction>(loadEvents),
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