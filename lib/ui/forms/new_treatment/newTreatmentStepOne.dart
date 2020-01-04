import 'dart:ffi';

import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/FormAddTreatmentState.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

class NewTreatmentStepOne extends StatefulWidget{
  
  void Function(CTreatment treatment) onContinue;
  NewTreatmentStepOne({this.onContinue});

  @override
  _NewTreatmentStepOneState createState() => _NewTreatmentStepOneState();
}

class _NewTreatmentStepOneState extends State<NewTreatmentStepOne> {
  Map<String,dynamic> formData=new Map();
 
  final _formKey = GlobalKey<FormState>();

  var isPermanent=false;
  bool isInitialised=false;
  MedicationType medicationType=MedicationType.inyeccion_subcutanea;
  String medicationName="";
  DateTime startDate=DateTime.now();
  DateTime endDate=DateTime.now();

  @override
  void initState() {
    //medicationTypes=MedicationType.values;
    super.initState();
    /*var treatmentStore=StoreProvider.of<AppState>(context).state.formAddTreatment.treatment;
    if(treatmentStore!=null){
      isPermanent=treatmentStore.isPermanent ?? false;
      medicationType=treatmentStore.medicationType ?? medicationType;
    }*/
    
    
  }

  @override 
  Widget build(BuildContext context) {
    
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    double height = MediaQuery.of(context).size.height;
    
    final List<MedicationType> medicationTypes=MedicationType.values.toList();
    return StoreConnector<AppState, FormAddTreatmentState>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.formAddTreatment,
      builder: (context, state) {
          if(!isInitialised){
            isPermanent=state.treatment.isPermanent ?? false;
            medicationType=state.treatment.medicationType ?? medicationType;
            medicationName=state.treatment.medicationName ?? "";
            startDate=state.treatment.startDate!=null ? DateTime.fromMillisecondsSinceEpoch(state.treatment.startDate.toInt()*1000):null;
            endDate=state.treatment.endDate!=null ? DateTime.fromMillisecondsSinceEpoch(state.treatment.endDate.toInt()*1000):null;
            formData["isPermanent"]=isPermanent;
            formData["medicationName"]=medicationName;
            formData["medicationType"]=medicationType.index;
            formData["startDate"]=state.treatment.startDate!=null ? state.treatment.startDate.toInt():null;
            formData["endDate"]=state.treatment.endDate!=null ? state.treatment.endDate.toInt():null;
            if(state.treatment.endDate!=null){
              print("endate : "+state.treatment.endDate.toInt().toString());
            }
            isInitialised=true;
          }
          
          return Form(
              
              key: _formKey,
              child: Container(
                height:height-200,
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  
                  children: <Widget>[
                    Expanded(
                      child:Column(
                        children: <Widget>[
                          TextFormField(
                          initialValue: medicationName,
                          onChanged: (value){
                            formData["medicationName"]=value;
                          },
                          onSaved: (value){
                            formData["medicationName"]=value;
                          },
                          decoration: InputDecoration(
                            labelText: "Nombre del farmaco",
                            hintText: ""
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Escribe el nombre del farmaco';
                            }
                            return null;
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.all(0),
                          value: isPermanent,
                          title: Text("¿Tratamiento permanente?"),
                          onChanged: (value){
                            formData["isPermanent"]=value;
                            if(!value){
                              formData["startDate"]=null;
                              formData["endDate"]=null;
                            }
                            setState(() {
                              isPermanent=value;
                            });
                          },
                          
                        
                        ),
                        Builder(
                          builder: (context){
                            if(!isPermanent){
                              return Container( 
                                child: Column(
                                  children:<Widget>[
                                        DateTimeField(
                                          onChanged:(DateTime value){
                                            formData["startDate"]=(value.millisecondsSinceEpoch~/1000);
                                            startDate=value;
                                          } ,
                                          initialValue: startDate,
                                          onSaved:(DateTime value){
                                            formData["startDate"]=(value.millisecondsSinceEpoch~/1000);
                                            startDate=value;
                                          } ,
                                          validator: (value){
                                            if (value==null) {
                                              return 'Selecciona una fecha para la cita';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Inicio del tratamiento",
                                            suffixIcon: Icon(Icons.calendar_today)
                                          ),
                                          format:formatter,
                                          onShowPicker: (context, currentValue) {
                                            return showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                initialDate: currentValue ?? DateTime.now(),
                                                lastDate: DateTime(2100));
                                          },

                                        ),
                                        DateTimeField(
                                          onChanged:(DateTime value){
                                            formData["endDate"]=(value.millisecondsSinceEpoch~/1000);
                                            endDate=value;
                                          } ,
                                          
                                          initialValue: endDate,
                                          onSaved:(DateTime value){
                                            formData["endDate"]=(value.millisecondsSinceEpoch~/1000);
                                            endDate=value;
                                          } ,
                                          validator: (value){
                                            print(value);
                                            print(formData["startDate"]);
                                            if (value==null) {
                                              return 'Selecciona una fecha';
                                            }
                                            if((value.millisecondsSinceEpoch~/1000) < formData["startDate"]){
                                              return 'La fecha debe ser mayor que la de inicio';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Final del tratamiento",
                                            suffixIcon: Icon(Icons.calendar_today)
                                          ),
                                          format:formatter,
                                          onShowPicker: (context, currentValue) {
                                            return showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                initialDate: currentValue ?? DateTime.now(),
                                                lastDate: DateTime(2100));
                                          },

                                        ),
                                      ]
                                      
                                    )
                                  );
                                }else{
                                  return Container(height: 0,width: 0,);
                                }

                              },
                            ),
                            SizedBox(
                              height: 10,
                            
                            ),
                            DropdownButton(
                              isDense: false,
                              isExpanded: true,
                              
                              
                              hint: Text("Forma de administracion"),
                              value: medicationType,
                              
                              onChanged: (MedicationType value){
                                formData["medicationType"]=value.index;
                                setState(() {
                                  medicationType=value;
                                });
                                
                              },
                              
                              items: medicationTypes
                                .map<DropdownMenuItem<MedicationType>>((MedicationType value) {
                                  return DropdownMenuItem<MedicationType>(
                                    value: value,
                                    
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                                      child:Text(medicationTypetoString(value).toUpperCase(),style: TextStyle(fontSize: 16),)
                                    ),
                                  );
                                })
                                .toList(),
                            ),
                            SizedBox(
                              height: 15,
                            
                            ),
                        ],
                      ),
                      
                      
                    ),
                    Align(
                            alignment: Alignment.bottomCenter,
                            child:RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical:15,horizontal: 0),
                              child:Container(
                                width:double.infinity,
                                child:Text("CONTINUAR",textAlign: TextAlign.center,),
                              
                              ),
                              onPressed: (){
                                if (_formKey.currentState.validate()) {
                                  formData["isPermanent"]=formData["isPermanent"] ? 1:0;
                                  CTreatment treatment = CTreatment.fromMap(formData);
                                  widget.onContinue(treatment);
                                }
                              },
                            )
                      )
                        
                      
                    
                    
                  ],
                ),
              ),
            );
        },
        onDidChange: (state){
          print(state.toString());
        },
    );
            
    
  }
}