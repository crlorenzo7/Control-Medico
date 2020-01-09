import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/repository/CDosisRepository.dart';
import 'package:control_medico3/repository/CTreatmentRepository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTreatmentsMiddleware() {
  final CTreatmentRepository repository=CTreatmentRepository();
  final CDosisRepository dosisRepository=CDosisRepository();

  final loadTreatments = _createLoadTreatments(repository);
  final saveTreatment = _saveTreatment(repository,dosisRepository);
  final deleteTreatment = _deleteTreatment(repository, dosisRepository);
  final updateTreatment = _updateTreatment(repository,dosisRepository);

  return [
    TypedMiddleware<AppState, LoadTreatmentsAction>(loadTreatments),
    TypedMiddleware<AppState, AddTreatmentAction>(saveTreatment),
    TypedMiddleware<AppState, DeleteTreatmentAction>(deleteTreatment),
    TypedMiddleware<AppState, UpdateTreatmentAction>(updateTreatment),
  ];
}


Middleware<AppState> _createLoadTreatments(CTreatmentRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.getCTreatments().then(
      (treatments) {
        store.dispatch(
          TreatmentsLoadedAction(treatments)
        );
      },
    ).catchError((_) => store.dispatch(TreatmentsNotLoadedAction()));

    next(action);
  };
}

Middleware<AppState> _saveTreatment(CTreatmentRepository repository,CDosisRepository dosisRepository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.createCTreatment(action.treatment).then(
      (id){
        
        action.treatment.id=id;
        action.treatment.configDosis.idTreatment=id;
        dosisRepository.generateCDosis(action.treatment).then((res){
          store.dispatch(TreatmentCreatedAction(action.treatment));
        });
      }
    ).catchError((_) => store.dispatch(TreatmentNotCreatedAction()));

    next(action);
  };
}

Middleware<AppState> _updateTreatment(CTreatmentRepository repository,CDosisRepository dosisRepository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.updateCTreatment(action.treatment).then(
      (id) async {
        
        await dosisRepository.deleteAllDosisTreatment(action.treatment);
        dosisRepository.generateCDosis(action.treatment).then((res){
          store.dispatch(TreatmentUpdatedAction(action.treatment));
        });
      }
    ).catchError((_) => store.dispatch(TreatmentNotUpdatedAction()));

    next(action);
  };
}

Middleware<AppState> _deleteTreatment(CTreatmentRepository repository,CDosisRepository dosisRepository){
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.deleteCTreatment(action.treatment.id).then(
      (id){
        dosisRepository.deleteAllDosisTreatment(action.treatment).then((res){
          store.dispatch(DeletedTreatmentAction(action.treatment.id));
        });
        
      }
    ).catchError((_) => store.dispatch(NotDeletedTreatmentAction()));

    next(action);
  };
}