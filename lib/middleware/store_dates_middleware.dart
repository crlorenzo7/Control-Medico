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
  final deleteDate = _deleteDate(repository);
  final updateDate = _updateDate(repository);

  return [
    TypedMiddleware<AppState, LoadDatesAction>(loadDates),
    TypedMiddleware<AppState, AddDateAction>(saveDate),
    TypedMiddleware<AppState, DeleteDateAction>(deleteDate),
    TypedMiddleware<AppState, UpdateDateAction>(updateDate),
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

Middleware<AppState> _updateDate(CEventRepository repository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.updateCEvent(action.date).then(
      (id){
        CAlarm().send(action.date);
        store.dispatch(DateUpdatedAction(action.date));
      }
    ).catchError((_) => store.dispatch(DateNotUpdatedAction()));

    next(action);
  };
}

Middleware<AppState> _deleteDate(CEventRepository repository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.deleteCEvent(action.cDate.id).then(
      (id){
        CAlarm().cancel(action.cDate);
        store.dispatch(DeletedDateAction(action.cDate.id));
      }
    ).catchError((_) => store.dispatch(DateNotCreatedAction()));

    next(action);
  };
}