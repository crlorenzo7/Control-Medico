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

  return [
    TypedMiddleware<AppState, LoadTreatmentsAction>(loadTreatments),
    TypedMiddleware<AppState, AddTreatmentAction>(saveTreatment),
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
        dosisRepository.generateCDosis(action.treatment);
        store.dispatch(TreatmentCreatedAction(action.treatment));
      }
    ).catchError((_) => store.dispatch(TreatmentNotCreatedAction()));

    next(action);
  };
}