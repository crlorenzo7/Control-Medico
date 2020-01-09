import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/bloc/treatments/TreatmentsBloc.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:control_medico3/ui/forms/new_treatment_form.dart';
import 'package:control_medico3/ui/treatment_item.dart';
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
                        final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => NewTreatmentForm()),);
                        StoreProvider.of<AppState>(context).dispatch(LoadTreatmentsAction());
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
                return CTreatmentItem(treatments[index]);
              }
            );
  }
}

