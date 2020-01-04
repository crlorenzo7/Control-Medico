
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CDosis.dart';
import 'package:control_medico3/model/CEvent.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/ui/date_item.dart';
import 'package:control_medico3/ui/event_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'loader.dart';

class EventPage extends StatefulWidget{
  final void Function() onInit;
  EventPage({@required this.onInit});

  @override
  _EventPageState createState() => _EventPageState();
  
  
  

}

class _EventPageState extends State<EventPage> {

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      distinct: true,
      converter: (Store<AppState> store) => AppState.fromStore(store.state),
      builder: (context, state) {
          return state.isLoadingEvents
              ? Loader()
              : _buildEventsList(state.events);
        },
        onDidChange: (state){
          print(state.toString());
        },
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
                  default: return DateItem(events[index] as CDate);break;
                }

              }
            );
  }

}



