import 'dart:ffi';

import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/FormAddTreatmentState.dart';
import 'package:control_medico3/model/enumerations/CBodyZone.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:control_medico3/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

class NewTreatmentStepThree extends StatefulWidget{
  
  void Function(CTreatment treatment) onContinue;
  void Function() onGoBack;
  NewTreatmentStepThree({this.onContinue,this.onGoBack});

  

  @override
  _NewTreatmentStepThreeState createState() => _NewTreatmentStepThreeState();
}

class _NewTreatmentStepThreeState extends State<NewTreatmentStepThree> {
  Map<String,dynamic> formData=new Map();
  
  List<Map<String,dynamic>> timelapses=[
      {"name":"Dias","value":1},
      {"name":"Semanas","value":7},
    ];

  final _formKey = GlobalKey<FormState>();

  var isDiary=false;
  int frequencyDays=1;
  int diaryTimes;
  List<int> initialDosisTime=[];
  Map<String,dynamic> timelapseSelected;
  List<int> dosisTime=[null];
  bool isInitialised=false;

  

  @override
  void initState() {
    
    super.initState();

  }

  @override 
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    
    
    return StoreConnector<AppState, FormAddTreatmentState>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.formAddTreatment,
      builder: (context, state) {
          if(!isInitialised){
            isDiary=state.treatment.configDosis.frequencyDays==1 ? true:false;
            diaryTimes=state.treatment.configDosis.diaryTimes ?? 1;
            initialDosisTime=state.treatment.configDosis.dosisTime ?? [];
            frequencyDays=state.treatment.configDosis.frequencyDays!=null ? state.treatment.configDosis.frequencyDays: 1;
            timelapseSelected=timelapses[0];
            
          }

          final childrenHour=<Widget>[];

          for(int i=0;i<diaryTimes;i++){
            childrenHour.add(_buildItemHour(context,i));
          }

          if(!isInitialised){
            isInitialised=true;
          }

          return Form(
              key:_formKey,
              child: Container(
                height:height-200,
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child:Column(
                        children: <Widget>[
                          SwitchListTile(
                            contentPadding: EdgeInsets.all(0),
                            value: isDiary,
                            title: Text("¿Tratamiento diario?"),
                            onChanged: (value){
                              setState(() {
                                isDiary=value;
                                if(!isDiary){
                                  diaryTimes=1;
                                  dosisTime=List.filled(diaryTimes, null);
                                }
                              });
                            },
                            
                          
                          ),
                          Builder(
                            builder: (BuildContext context){
                              return isDiary ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child:Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: TextFormField(
                                              initialValue: diaryTimes.toString(),
                                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                              keyboardType: TextInputType.numberWithOptions(),
                                              onChanged: (value){
                                                setState(() {
                                                  diaryTimes=int.parse(value);
                                                  dosisTime=List.filled(diaryTimes, null);
                                                });
                                                
                                              },
                                      )
                                    )
                                  ),
                                  Text("veces al dia")
                                ],
                              
                              ):Container(
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Frecuencia de administracion"),
                                    Row(
                                      children: <Widget>[
                                        Text("Cada"),
                                        Expanded(
                                          child:Padding(
                                            padding: EdgeInsets.only(right: 15,left: 15),
                                            child: SizedBox(
                                              width:60,
                                              height: 30,
                                              child: TextFormField(
                                                      initialValue: frequencyDays.toString(),
                                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                                      keyboardType: TextInputType.numberWithOptions(),
                                                      //decoration: InputDecoration(border: InputBorder.none),
                                                      onChanged: (value){
                                                        frequencyDays=int.parse(value);
                                                      },
                                              ),
                                            ) 
                                            
                                          ) ,
                                        ),
                                        Expanded(
                                          child:DropdownButton(
                                            isDense: false,
                                            isExpanded: true,
                                            
                                            
                                            
                                            value: timelapseSelected,
                                            
                                            onChanged: (Map<String,dynamic> value){
                                              //formData["medicationType"]=value.index;
                                              setState(() {
                                                timelapseSelected=value;
                                                
                                              });
                                              
                                            },
                                            
                                            items: timelapses
                                              .map<DropdownMenuItem<Map<String,dynamic>>>((Map<String,dynamic> value) {
                                                return DropdownMenuItem<Map<String,dynamic>>(
                                                  value: value,
                                                  
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                                                    child:Text(value["name"].toUpperCase(),style: TextStyle(fontSize: 16),)
                                                  ),
                                                );
                                              })
                                              .toList(),
                                          ),
                                            
                                          
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Hora de aplicacion"),
                                Column(
                                  children: childrenHour
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                    
                    
                    Container(
                      child:Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical:15,horizontal: 0),
                                child:Container(
                                  width:double.infinity,
                                  child:Text("ATRAS",textAlign: TextAlign.center,),
                                
                                ),
                                onPressed: (){
                                  widget.onGoBack();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical:15,horizontal: 0),
                                child:Container(
                                  width:double.infinity,
                                  child:Text("FINALIZAR",textAlign: TextAlign.center,),
                                
                                ),
                                onPressed: (){
                                  if (_formKey.currentState.validate()) {
                                    CTreatment treatment = CTreatment.fromMap(state.treatment.toMap());
                                    
                                    CConfigDosis config=CConfigDosis.fromMap(state.treatment.configDosis.toMap());
                                    config.diaryTimes = diaryTimes;
                                    config.frequencyDays=frequencyDays*timelapseSelected["value"];
                                    config.dosisTime=dosisTime;
                                    treatment.configDosis=config;
                                    
                                    
                                    
                                    /*List<int> applicationZones=ordenes.where((item)=>item!=null).map((item)=>item["zone"].index).toList().cast<int>();
                                    
                                    treatment.setApplicationZones = applicationZones;
                                    treatment.setLastDosisDate=BigInt.from(lastDosisDate.millisecondsSinceEpoch~/1000);
                                    treatment.setLastDosisBodyZone=lastDosisBodyZone["zone"];
                                    print(treatment.toMap());
                                    //print(formData);*/
                                    widget.onContinue(treatment);
                                  }
                                },
                              ),
                            )
                            
                            
                          ],
                      )
                    )
                  ],
                )
              )
          );
        },
        onDidChange: (state){
          print(state.toString());
        },
    );    
    
  }


  

  Widget _buildItemHour(BuildContext context,int index){
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");

    if(initialDosisTime.isNotEmpty && !isInitialised){
      dosisTime[index]=initialDosisTime[index];
    }

    TextEditingController textTimeController;
    FocusNode focusTime;

    focusTime=FocusNode();
    textTimeController=TextEditingController();
    focusTime.addListener((){
      if (focusTime.hasFocus) {
        textTimeController.clear();
      }
    });
    
    print(dosisTime[index]);
    //print(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000).toString());
    return Container(
        height: 60,
        child:Row(
          children: <Widget>[
            Text((index+1).toString()+"º"),
            Expanded(
              child:Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  //color: Colors.black,
                  child: Stack(
                    children: <Widget>[
                      
                      TextFormField(
                        controller: TextEditingController(text:dosisTime[index]!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000).toUtc()).toUpperCase():null,),
                        //initialValue: dosisTime[index]!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000)).toUpperCase():null,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Selecciona una hora';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Hora de la dosis",
                          suffixIcon: Icon(Icons.query_builder)
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          int time=await TimeUtils().selectTime(context, dosisTime[index]);
                          setState(() {
                            dosisTime[index]=time;
                          });
                        },
                        child:Container(
                          color: Colors.transparent,
                        ),
                      )
                      
                      
                    ],
                  ),
                )
              )
            )
          ],
        ) ,
      );
  }
}

