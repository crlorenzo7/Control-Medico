
import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/library/month_picker_strip.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CDosis.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/ui/forms/new_date_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
//import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:redux/redux.dart';

import 'date_item.dart';
import 'event_item.dart';
import 'loader.dart';




class HistoryPage extends StatefulWidget{
  
  final void Function() onInit;
  HistoryPage({@required this.onInit});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage>{
  
  DateTime selectedMonth=DateTime(DateTime.now().year,DateTime.now().month);

  @override
  void initState() {
    
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Builder(
                  builder: (context){
                    return StoreConnector<AppState, AppState>(
                      distinct: true,
                      converter: (Store<AppState> store) => AppState.fromStore(store.state),
                      builder: (context, state) {
                          return state.initialDate==0
                              ? Loader()
                              : _buildHistory(context,state);
                        },
                    );
                  },
                );
            
          
                
  }

  Widget _buildHistory(BuildContext context,AppState state){
    initializeDateFormatting();
    final DateFormat dateFormat = new DateFormat('MMMM yyyy');
    double height = MediaQuery.of(context).size.height;
    DateTime initialDate=DateTime.fromMillisecondsSinceEpoch(state.initialDate*1000);
    return Container(
      height: height-200,
      child: Column(
        children: <Widget>[
          MonthStrip(
              format: 'MMM yyyy',
              from:  DateTime(initialDate.year,initialDate.month),
              to: new DateTime(DateTime.now().year,DateTime.now().month),
              initialMonth: selectedMonth,
              height: 48.0,
              viewportFraction: 0.25,
              onMonthChanged: (v) {
                setState(() {
                  selectedMonth = v;
                });
              },
            ),
            new Divider(
              height: 1.0,
            ),
            Container(
              height: height-248,
              child:Builder(
                builder: (context){
                  
                        return state.isLoadingHistory
                            ? Loader()
                            : _buildEventsList(state.eventsHistory);/*Container(
                                child: new Center(
                                  child: new Text(dateFormat.format(selectedMonth)),
                                )
                              );*/
                      },
                  
                
              ),
            )
            
        ],
      ),
    );
  }

  Widget _buildEventsList(List<CEvent> events){
    return events.isEmpty ? Column(
      
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  
                  child:Text("No hay eventos en el horizonte",style: TextStyle(fontSize: 20),)
                )
              ],
            ):
           ListView.builder(
                
              padding: EdgeInsets.all(0.0),
              
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                CEventType type=events[index].type;
                switch(type){
                  case CEventType.alarm: return DosisItem(events[index] as CDosis);break;
                  default: return DateItem(events[index] as CDate,false);break;
                }

              }
            );
  }
  

}