import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/bloc/treatments/TreatmentsBloc.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:control_medico3/ui/forms/new_treatment_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'loader.dart';

class TreatmentsPage extends StatefulWidget{

  final void Function() onInit;
  TreatmentsPage({@required this.onInit});

  @override
  _TreatmentsPageState createState() => _TreatmentsPageState();

}

class _TreatmentsPageState extends State<TreatmentsPage>{

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
            Stack(
              children: <Widget>[
                Builder(
                  builder: (context){
                    return StoreConnector<AppState, AppState>(
                      distinct: true,
                      converter: (Store<AppState> store) => AppState.fromStore(store.state),
                      builder: (context, state) {
                          return state.isLoadingTreatments
                              ? Loader()
                              : _buildTreatmentsList(state.treatments);
                        },
                    );
                  },
                ),
                Positioned(
                  bottom:15,
                  right:15,
                  child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () async{
                        StoreProvider.of<AppState>(context).dispatch(InitFormAddTreatmentAction());
                        final result = await Navigator.push(context,
      // Create the SelectionScreen in the next step.
                          
                          MaterialPageRoute(builder: (context) => NewTreatmentForm()),
                        );
                      },
                    )  
                  )
                
              ],
            );
                
  }

  Widget _buildTreatmentsList(List<CTreatment> treatments){
    return treatments.isEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:Text("No sigues ningun tratamiento",style: TextStyle(fontSize: 20),)
                )
              ],
            ):  ListView.builder(
                
              padding: EdgeInsets.all(0.0),
              
              itemCount: treatments.length,
              itemBuilder: (BuildContext context, int index) {
                return TreatmentsItem(treatments[index]);
              }
            );
  }
}

class TreatmentsItem extends StatelessWidget{

  CTreatment treatment;
  TreatmentsItem(this.treatment);
  
  @override
  Widget build(BuildContext context) {

    
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    String startDate=formatter.format(DateTime.fromMillisecondsSinceEpoch(treatment.startDate.toInt()*1000));
    String endDate=formatter.format(DateTime.fromMillisecondsSinceEpoch(treatment.endDate.toInt()*1000));
    String isPermanent= treatment.isPermanent ? "Permanente,":startDate+" - "+endDate+", ";
    String timelapse=treatment.configDosis.dosisTime.length.toString()+" dosis cada "+_parseTimelapse(treatment.configDosis.frequencyDays);

    return 
           Container(
              padding: EdgeInsets.all(0.0),
              //height: 70,
              
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: .5,color: Color.fromRGBO(120, 120, 120, .3),style:BorderStyle.solid)),
                color:Colors.transparent
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(top:15,bottom: 15,left: 15,right:15),
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              
                              children: <Widget>[
                                Text(treatment.medicationName,style: TextStyle(color: Colors.black,fontSize: 16)),
                                Divider(height: 5,color: Colors.transparent,),
                                Text(medicationTypetoString(treatment.medicationType),style: TextStyle(color: Colors.black87,fontSize: 12)),
                                Divider(height: 5,color: Colors.transparent,),
                                Text(isPermanent+timelapse,style: TextStyle(color: Colors.black87,fontSize: 12))
                              ],
                            ),
                  ),
                  
                  
                ],
              )
            );
                
  }

  String _parseTimelapse(int days){
    if(days<7){
      return days.toString()+" dias";
    }else{
      int semanas=days~/7;
      return semanas.toString()+" semanas";
    }
  }

}