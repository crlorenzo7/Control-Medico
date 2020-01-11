import 'dart:async';

import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/FormAddDateState.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

import '../../time_utils.dart';
import '../loader.dart';


class NewDateForm extends StatefulWidget{
  
  bool edition=false;

  NewDateForm({this.edition=false});

  @override
  _NewDateFormState createState() => _NewDateFormState();

}

class _NewDateFormState extends State<NewDateForm>{
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> formData=new Map();
  
  String title;
  int day;
  int time;
  int id;


  bool isInitialized=false;

  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    formData["type"]=CEventType.date.index;

    
    return Scaffold(
              appBar: AppBar(
                title: Text("Nueva Cita",style: TextStyle(fontWeight: FontWeight.normal),textAlign: TextAlign.center),
                
                
              ),
              body:Builder(
                builder:(context){
                  return StoreConnector<AppState, FormAddDateState>(
                      distinct: true,
                      converter: (Store<AppState> store) => AppState.fromStore(store.state).formAddDate,
                      builder: (context, state) {
                          return state.isProcessing
                              ? Loader()
                              : _buildForm(state);
                        },
                    );
                  
                  
                }
              )
          );
            
           
  }

  Widget _buildForm(FormAddDateState state){
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a");

    if(!isInitialized){
      if(state.date!=null){
        title=state.date.title ?? null;
        day = state.date.day !=null ? state.date.day.toInt():null;
        DateTime finalTime=state.date.time != null ? DateTime.fromMillisecondsSinceEpoch(state.date.time.toInt()*1000):null;
        time = finalTime!=null ? ((finalTime.hour*3600)+(finalTime.minute*60)):null;
        id=state.date.id ?? null;
      }
      isInitialized=true;
    }

    return state.success ? Column(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("cita creada con exito",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 20,),
                                  RaisedButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      StoreProvider.of<AppState>(context).dispatch(DateConfirmCreationAction());
                                      Navigator.pop(context);
                                    },
                                    child:Padding(
                                      padding:EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                      child:Text("Aceptar",style: TextStyle(color: Colors.white),)
                                    ) 
                                    
                                  )
                                ],
                              ) 
                            )
                          )
                        ],
                      ):Form(
                        key: _formKey,
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  initialValue: title,
                                  onChanged: (value){
                                    title=value;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Titulo",
                                    hintText: "Titulo de la cita..."
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Escribe un titulo para tu cita';
                                    }
                                    return null;
                                  },
                                ),
                                Container(
                  //color: Colors.black,
                                  height:60,
                                  child: Stack(
                                    children: <Widget>[
                                      
                                      TextFormField(
                                        controller: TextEditingController(text:day!=null ? formatter.format(DateTime.fromMillisecondsSinceEpoch(day*1000)):null,),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Selecciona una fecha';
                                          }
                                          return null;
                                        },
                                        //initialValue: dosisTime[index]!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000)).toUpperCase():null,
                                        decoration: InputDecoration(
                                          hintText: "Fecha de la cita",
                                          suffixIcon: Icon(Icons.calendar_today)
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          int date=await TimeUtils().selectDate(context, day);
                                          if(date!=null){
                                            setState(() {
                                              
                                              day=date;
                                            });
                                          }
                                        },
                                        child:Container(
                                          color: Colors.transparent,
                                        ),
                                      )
                                      
                                      
                                    ],
                                  ),
                                ),
                                Container(
                  //color: Colors.black,
                                  height:60,
                                  child: Stack(
                                    children: <Widget>[
                                      
                                      TextFormField(
                                        controller: TextEditingController(text:time!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(time*1000).toUtc()):null,),
                                        //initialValue: dosisTime[index]!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000)).toUpperCase():null,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Selecciona una Hora';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Hora de la cita",
                                          suffixIcon: Icon(Icons.query_builder)
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          int timeRes=await TimeUtils().selectTime(context, time);
                                          if(timeRes!=null){
                                            setState(() {
                                              
                                              time=timeRes;
                                            });
                                          }
                                        },
                                        child:Container(
                                          color: Colors.transparent,
                                        ),
                                      )
                                      
                                      
                                    ],
                                  ),
                                ),
                                /*DateTimeField(
                                  onChanged:(DateTime value){
                                    formData["day"]=(value.millisecondsSinceEpoch~/1000);
                                  } ,
                                  validator: (value){
                                    if (value==null) {
                                      return 'Selecciona una fecha para la cita';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Fecha de la cita",
                                    suffixIcon: Icon(Icons.calendar_today)
                                  ),
                                  format:formatter,
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: currentValue ?? (DateTime.now().add(Duration(hours: 24))),
                                        lastDate: DateTime(2100));
                                  },

                                ),
                                DateTimeField(
                                  onChanged:(DateTime value){
                                    formData["time"]=((value.millisecondsSinceEpoch)~/1000);
                                  } ,
                                  validator: (value){
                                    if (value==null) {
                                      return 'Selecciona una fecha para la cita';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Hora de la cita",
                                    suffixIcon: Icon(Icons.watch_later)
                                  ),
                                  format:formatterTime,
                                  onShowPicker: (context, currentValue) async{
                                    final time=await showTimePicker(
                                      initialTime: TimeOfDay(hour: 0,minute: 0),
                                      context: context
                                    );
                                    return DateTimeField.convert(time);
                                    
                                  },

                                ),*/
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  elevation: 5,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      formData["title"]=title;
                                      formData["day"]=day;
                                      formData["time"]=day+time;
                                      if(id!=null){
                                        formData["id"]=id;
                                      }
                                      CDate cita=CDate.fromMap(formData);
                                      cita.type=CEventType.date;
                                      if(widget.edition){
                                        StoreProvider.of<AppState>(context).dispatch(UpdateDateAction(cita));
                                      }else{
                                        StoreProvider.of<AppState>(context).dispatch(AddDateAction(cita));
                                      }
                                    }
                                  },
                                  child:Padding(
                                    padding:EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                    child:Text("confirmar cita",style: TextStyle(color: Colors.white),)
                                  ) 
                                  
                                )
                              ],
                            ),
                          ),
                      );
  }

}
