
import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/actions/eventActions.dart';
import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/bloc/dates/DatesBloc.dart';
import 'package:control_medico3/bloc/treatments/TreatmentsBloc.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:control_medico3/ui/events_page.dart';
import 'package:control_medico3/ui/dates_page.dart';
import 'package:control_medico3/ui/treatments_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'history_page.dart';


class HomePage extends StatefulWidget{
  
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();

}



class _HomePageState extends State<HomePage>{
  String title="Mi Control Medico";
  bool notificationLaunch=false;
  
  
  
 
  @override
  void initState(){
    
    
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    void _handleTabChange(int index){
      print(index);
      
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Stack(
      children: <Widget>[
        
        DefaultTabController(
          length: 4,
          child:Scaffold(
            
              appBar: AppBar(
                centerTitle: true,
                title: Text(title,style: TextStyle(fontWeight: FontWeight.normal),textAlign: TextAlign.center),
                
                bottom:TabBar(
                  onTap: _handleTabChange,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(text: "AGENDA"),
                    Tab(text: "CITAS"),
                    Tab(text: "TRATAMIENTOS"),
                    Tab(text: "HISTORIAL")
                  ],
                )
              ),
              body:Container(
                color:Colors.white,
                child:TabBarView(
                
                    children: [
                      EventPage(onInit:() {
                          StoreProvider.of<AppState>(context).dispatch(LoadEventsAction());
                        }),
                      DatesPage(onInit:(){
                        StoreProvider.of<AppState>(context).dispatch(LoadDatesAction());
                      }),
                      TreatmentsPage(onInit:(){
                        StoreProvider.of<AppState>(context).dispatch(LoadTreatmentsAction());
                      }),
                      HistoryPage(onInit:(){
                        StoreProvider.of<AppState>(context).dispatch(InitHistoryAction());
                      }),
                    ],
                  )
                )
            )
        ),
        Builder(
          builder:(context){
            
            return notificationLaunch ? Container(
              width: width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.alarm)
                ],
              ),
            ):Container(height: 0,);
          } ,
        ),
      ],
    ); 
           
  }

}
