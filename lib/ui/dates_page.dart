
import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/ui/forms/new_date_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

import 'date_item.dart';
import 'loader.dart';




class DatesPage extends StatefulWidget{
  
  final void Function() onInit;
  DatesPage({@required this.onInit});

  @override
  _DatesPageState createState() => _DatesPageState();
}
class _DatesPageState extends State<DatesPage>{
  

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
                          return state.isLoadingDates
                              ? Loader()
                              : _buildDatesList(state.dates);
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
                          final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => NewDateForm()));
                          StoreProvider.of<AppState>(context).dispatch(LoadDatesAction());
                      },
                    )  
                  )
                
              ],
            );
                
  }

  Widget _buildDatesList(List<CEvent> dates){
    return dates.isEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:Text("No hay citas en el horizonte",style: TextStyle(fontSize: 20),)
                )
              ],
            ):  ListView.builder(
                
              padding: EdgeInsets.all(0.0),
              
              itemCount: dates.length,
              itemBuilder: (BuildContext context, int index) {
                return DateItem(dates[index] as CDate);
              }
            );
  }

  

}

