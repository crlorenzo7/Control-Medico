import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CAlarm.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/enumerations/CEventState.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreDatesMiddleware() {
  final CEventRepository repository=CEventRepository();

  final loadDates = _createLoadDates(repository);
  final saveDate = _saveDate(repository);

  return [
    TypedMiddleware<AppState, LoadDatesAction>(loadDates),
    TypedMiddleware<AppState, AddDateAction>(saveDate),
  ];
}


Middleware<AppState> _createLoadDates(CEventRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    Map<String,dynamic> query=new Map();
    query["type"]=CEventType.date.index;
    repository.getCEvents(query: query).then(
      (dates) {
        store.dispatch(
          DatesLoadedAction(dates)
        );
      },
    ).catchError((_) => store.dispatch(DatesNotLoadedAction()));

    next(action);
  };
}

Middleware<AppState> _saveDate(CEventRepository repository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.createCEvent(action.date).then(
      (id){
        
        action.date.id=id;
        CAlarm().send(action.date);
        store.dispatch(DateCreatedAction(action.date));
      }
    ).catchError((_) => store.dispatch(DateNotCreatedAction()));

    next(action);
  };
}