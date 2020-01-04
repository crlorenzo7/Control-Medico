import 'dart:async';

import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/FormAddDateState.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/repository/CEventRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

import '../loader.dart';


class NewDateForm extends StatefulWidget{
  

  NewDateForm();

  @override
  _NewDateFormState createState() => _NewDateFormState();

}

class _NewDateFormState extends State<NewDateForm>{
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> formData=new Map();
  

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
                              : _buildForm(state.success);
                        },
                    );
                  
                  
                }
              )
          );
            
           
  }

  Widget _buildForm(bool success){
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    return success ? Column(
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
                                  onChanged: (value){
                                    formData["title"]=value;
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
                                DateTimeField(
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
                                        firstDate: DateTime.now(),
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

                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  elevation: 5,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      
                                      formData["time"]=formData["day"]+formData["time"];
                                      CDate cita=CDate.fromMap(formData);
                                      cita.type=CEventType.date;
                                      StoreProvider.of<AppState>(context).dispatch(AddDateAction(cita));

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
/*
if(_formState==0){
                    return Form(
                              key: _formKey,
                              child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextFormField(
                                        onChanged: (value){
                                          formData["title"]=value;
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
                                      DateTimeField(
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
                                              firstDate: DateTime.now(),
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

                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        elevation: 5,
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {
                                           
                                            formData["time"]=formData["day"]+formData["time"];
                                            CDate cita=CDate.fromMap(formData);
                                            print(cita.toMap());
                                            //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Procesando datos')));
                                            fixState(1);
                                            //var result=widget.cEventRepository.createCEvent(cita);
                                            _timer = new Timer(const Duration(milliseconds: 3000), () {
                                              fixState(2);
                                            });
                                            
                                            //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Cita creada')));
                                            //Timer(Duration(seconds: 5), ()=>Navigator.pop(context));

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
                  }else if(_formState==1){
                    return Column(
                              children: <Widget>[
                                Expanded(child: Center(child: CircularProgressIndicator()))
                              ],
                            );
                  }else{
                    return Column(
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
                            );
                  }*/