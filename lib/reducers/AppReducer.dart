import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/reducers/formAddTreatmentReducer.dart';

import 'DatesReducer.dart';
import 'EventsReducer.dart';
import 'LoadingReducer.dart';
import 'TreatmentsReducer.dart';
import 'formAddDateReducer.dart';
import 'loadingDatesReducer.dart';
import 'loadingTreatmentsReducer.dart';

AppState appReducer(AppState state, action){
  return AppState(
    isLoadingEvents:loadingEventsReducer(state.isLoadingEvents,action),
    isLoadingDates:loadingDatesReducer(state.isLoadingDates,action),
    isLoadingTreatments:loadingTreatmentsReducer(state.isLoadingTreatments,action),
    dates:datesReducer(state.dates,action),
    treatments: treatmentsReducer(state.treatments,action),
    events: eventsReducer(state.events,action),
    formAddDate: formAddDateReducer(state.formAddDate,action),
    formAddTreatment: formAddTreatmentReducer(state.formAddTreatment, action)
  );
}