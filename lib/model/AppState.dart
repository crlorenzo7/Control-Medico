import 'package:control_medico3/model/FormAddTreatmentState.dart';
import 'package:meta/meta.dart';

import 'CDate.dart';
import 'CEvent.dart';
import 'CTreatment.dart';
import 'FormAddDateState.dart';

@immutable
class AppState{
  final bool isLoadingEvents;
  final bool isLoadingTreatments;
  final bool isLoadingDates;
  final bool isLoadingHistory;
  final int initialDate;
  final List<CEvent> eventsHistory;
  final List<CEvent> events;
  final List<CEvent> dates;
  final List<CTreatment> treatments;
  final FormAddDateState formAddDate;
  final FormAddTreatmentState formAddTreatment;

  AppState({
    this.initialDate=0,
    this.isLoadingEvents=false, 
    this.isLoadingDates=false,
    this.isLoadingTreatments=false,
    this.isLoadingHistory=false,
    this.events=const [],
    this.dates=const [],
    this.treatments=const [],
    this.eventsHistory=const [],
    this.formAddDate= const FormAddDateState(),
    this.formAddTreatment=const FormAddTreatmentState()
  });

  factory AppState.loading() => AppState(isLoadingEvents: true);

  factory AppState.fromStore(AppState state)=>AppState(
    initialDate: state.initialDate,
    isLoadingEvents: state.isLoadingEvents,
    isLoadingDates: state.isLoadingDates,
    isLoadingTreatments: state.isLoadingTreatments,
    isLoadingHistory: state.isLoadingHistory,
    events: state.events,
    dates:state.dates,
    eventsHistory: state.eventsHistory,
    treatments:state.treatments,
    formAddDate:state.formAddDate
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          initialDate == other.initialDate &&
          isLoadingEvents == other.isLoadingEvents &&
          isLoadingDates == other.isLoadingDates &&
          isLoadingTreatments == other.isLoadingTreatments &&
          isLoadingHistory==other.isLoadingHistory &&
          eventsHistory==other.eventsHistory &&
          events == other.events &&
          dates == other.dates &&
          treatments == other.treatments &&
          formAddDate == other.formAddDate;

  @override
  String toString() {
    return 'AppState{isLoadingEvents: $isLoadingEvents,isLoadingDates: $isLoadingDates,isLoadingTreatments: $isLoadingTreatments, events: $events, dates: $dates, treatments: $treatments}';
  }
}