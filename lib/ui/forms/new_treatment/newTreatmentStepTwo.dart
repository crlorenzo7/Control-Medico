import 'dart:ffi';

import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/FormAddTreatmentState.dart';
import 'package:control_medico3/model/enumerations/CBodyZone.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

import '../../../time_utils.dart';

class NewTreatmentStepTwo extends StatefulWidget{
  
  void Function(CTreatment treatment) onContinue;
  void Function() onGoBack;
  NewTreatmentStepTwo({this.onContinue,this.onGoBack});

  

  @override
  _NewTreatmentStepTwoState createState() => _NewTreatmentStepTwoState();
}

class _NewTreatmentStepTwoState extends State<NewTreatmentStepTwo> {
  Map<String,dynamic> formData=new Map();
  List<int> initialSelected=[];
  int initialLastDosisBodyZone;
  List<Map<String,dynamic>> listBodyZones=[
      {"zone":CBodyZone.A,"value":false},
      {"zone":CBodyZone.B,"value":false},
      {"zone":CBodyZone.C,"value":false},
      {"zone":CBodyZone.D,"value":false},
      {"zone":CBodyZone.E,"value":false},
      {"zone":CBodyZone.F,"value":false},
      {"zone":CBodyZone.G,"value":false},
      {"zone":CBodyZone.H,"value":false}
    ];
  List<Map<String,dynamic>> listBodyZonesSelected=[];
  List<Map<String,dynamic>> ordenes=[];
  DateTime lastDosisDate;
  bool isInitialised=false;
  bool lastDosisInitialized=false;
  Map<String,dynamic> lastDosisBodyZone;
  TextEditingController textTimeController;
  FocusNode focusTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusTime=FocusNode();
    textTimeController=TextEditingController();
    focusTime.addListener((){
      if (focusTime.hasFocus) {
        textTimeController.clear();
      }
    });
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
            initialSelected=state.treatment.applicationZones ?? [];
            lastDosisDate = state.treatment.lastDosisDate!=null ? DateTime.fromMillisecondsSinceEpoch(state.treatment.lastDosisDate.toInt()*1000):null;
            initialLastDosisBodyZone = state.treatment.lastDosisBodyZone!=-1 ? state.treatment.lastDosisBodyZone:null;
            
          }

          final children=<Widget>[];
          final children2=<Widget>[];

          final childrenSelected=<Widget>[];
          final childrenSelected2=<Widget>[];
          
          for(int i=0;i<listBodyZones.length;i++){
            (i%2==0) ? children.add(_builItemChecklistZone(context,i)) : children2.add(_builItemChecklistZone(context,i));
          }

          for(int i=0;i<listBodyZonesSelected.length;i++){
            (i%2==0) ? childrenSelected.add(_builItemChecklistZoneSelected(context,i)) : childrenSelected2.add(_builItemChecklistZoneSelected(context,i));
          }

          
          if(initialLastDosisBodyZone!=null && !lastDosisInitialized){
            lastDosisBodyZone=listBodyZones.where((item)=>item["zone"].index==initialLastDosisBodyZone).toList()[0];
            lastDosisInitialized=true;
          }
          if(!isInitialised){
            isInitialised=true;
          }

          return state.treatment.medicationType==MedicationType.inyeccion_subcutanea ? Form(
            key: _formKey,
            child:Column(
              
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text("Selecciona las zonas de Inyección"),
                      Container(
                        child:Image.asset("assets/images/body_zones.png",fit: BoxFit.fitWidth,)
                      ),  
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: children
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: children2
                            ),
                        ],
                      ),
                    ]

                  )
                ),
                Builder(
                  builder: (BuildContext context){
                    return listBodyZones.where((item)=>item["value"]==true).toList().length>0 ? _buildRotationOrderSelector(context, childrenSelected, childrenSelected2):Container(height: 0,);
                  },
                ),
                Container(
                  //color: Colors.black,
                  height:60,
                  child: Stack(
                    children: <Widget>[
                      
                      TextFormField(
                        controller: TextEditingController(text:lastDosisDate!=null ? formatter.format(lastDosisDate):null,),
                        //initialValue: dosisTime[index]!=null ? formatterTime.format(DateTime.fromMillisecondsSinceEpoch(dosisTime[index]*1000)).toUpperCase():null,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Selecciona una fecha';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Fecha anterior/proxima dosis",
                          suffixIcon: Icon(Icons.calendar_today)
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          int date=await TimeUtils().selectDate(context, (lastDosisDate!=null ? (lastDosisDate.millisecondsSinceEpoch~/1000):null));
                          if(date!=null){
                            setState(() {
                              lastDosisDate=DateTime.fromMillisecondsSinceEpoch(date*1000);
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
                SizedBox(
                  height: 30,
                
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Zona de la ultima/proxima dosis",textAlign: TextAlign.start,),
                    DropdownButton(
                      isDense: false,
                      isExpanded: true,
                      
                      
                      hint: Text("selecciona una zona"),
                      value: lastDosisBodyZone,
                      
                      onChanged: (Map<String,dynamic> value){
                        //formData["medicationType"]=value.index;
                        setState(() {
                          lastDosisBodyZone=value;
                        });
                        
                      },
                      
                      items: listBodyZonesSelected
                        .map<DropdownMenuItem<Map<String,dynamic>>>((Map<String,dynamic> value) {
                          return DropdownMenuItem<Map<String,dynamic>>(
                            value: value,
                            
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                              child:Text(("Zona "+value["zone"].toString().split(".")[1]).toUpperCase(),style: TextStyle(fontSize: 16),)
                            ),
                          );
                        })
                        .toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                
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
                              child:Text("CONTINUAR",textAlign: TextAlign.center,),
                            
                            ),
                            onPressed: (){
                              if (_formKey.currentState.validate()) {
                                CTreatment treatment = CTreatment.fromMap(state.treatment.toMap());
                                if(state.treatment.configDosis!=null){
                                  CConfigDosis config=CConfigDosis.fromMap(state.treatment.configDosis.toMap());
                                  treatment.configDosis=config;
                                }
                                List<int> applicationZones=ordenes.where((item)=>item!=null).map((item)=>item["zone"].index).toList().cast<int>();
                                
                                treatment.setApplicationZones = applicationZones;
                                treatment.setLastDosisDate=BigInt.from(lastDosisDate.millisecondsSinceEpoch~/1000);
                                treatment.setLastDosisBodyZone=lastDosisBodyZone["zone"];
                                print(treatment.toMap());
                                //print(formData);
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
          ):Container(
            height: height-200,
            child:Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[
                Expanded(
                  child: Text("No hay opciones configurables, haga click en continuar",style: TextStyle(fontSize: 20,height: 1.2),textAlign: TextAlign.center,),
                ),
                Row(
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
                              child:Text("CONTINUAR",textAlign: TextAlign.center,),
                            
                            ),
                            onPressed: (){
                              CTreatment treatment = CTreatment.fromMap(state.treatment.toMap());
                              
                              widget.onContinue(treatment);
                              
                            },
                          ),
                        )
                        
                        
                      ],
                )
                
                
              ]
            )
          );
        },
        onDidChange: (state){
          print(state.toString());
        },
    );
            
    
  }

  Widget _buildRotationOrderSelector(BuildContext context,List<Widget> children,List<Widget> children2){
    return Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget>[
                Text("Establece el orden de rotacion"), 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: children
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: children2
                      ),
                  ],
                ),
              ]

            )
          );
  }

  Widget _builItemChecklistZone(BuildContext context,int index){

    if(initialSelected.indexOf(listBodyZones[index]["zone"].index)!=-1 && !isInitialised){
      listBodyZones[index]["value"]=true;
      listBodyZonesSelected.add(listBodyZones[index]);
      ordenes.add(listBodyZones[index]);
    }

    double width = MediaQuery.of(context).size.width;
    return Container(
              width:(((width-50)/2)),
              height: 35,
              margin: EdgeInsets.symmetric(vertical: 5),
              child:CheckboxListTile(
                title: Text("Zona "+listBodyZones[index]["zone"].toString().split(".")[1]),
                value: listBodyZones[index]["value"],
                onChanged: (value){
                  setState(() {
                    listBodyZones[index]["value"]=value;
                    
                    listBodyZonesSelected=listBodyZones.where((item) => item["value"]==true).toList();
                    int place=ordenes.indexOf(listBodyZones[index]);
                    if(value){
                      
                      if(place==-1){
                        ordenes.add(null);
                      }
                    }else{
                      if(place!=-1){
                        if(lastDosisBodyZone==ordenes[place]){
                          lastDosisBodyZone=null;
                        }
                        ordenes.removeAt(place);
                        
                      }
                      
                    }
                      /*if(item["value"]){
                        return item;
                      }else{
                        return null;
                      }
                    }).toList();*/
                    print(listBodyZonesSelected);
                  });
                  
                },
              ),
            );
  }

  Widget _builItemChecklistZoneSelected(BuildContext context,int index){
    double width = MediaQuery.of(context).size.width;
    print(index);
    return Container(
              width:(((width-50)/2)),
              height: 35,
              margin: EdgeInsets.symmetric(vertical: 5),
              child:Row(
                children: <Widget>[
                  Text((index+1).toString()+"º"),
                  
                  Expanded(
                    
                    child:Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:DropdownButton(
                        isDense: false,
                        isExpanded: true,
                        
                        hint: Text("zona"),
                        value: ordenes[index],
                        
                        onChanged: (Map<String,dynamic> value){
                          
                          setState(() {
                            ordenes[index]=value;
                            
                          });
                          
                        },
                        
                        items: listBodyZonesSelected
                          .map<DropdownMenuItem<Map<String,dynamic>>>((Map<String,dynamic> value) {
                            return DropdownMenuItem<Map<String,dynamic>>(
                              value: value,
                              
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                                child:Text(value["zone"].toString().split(".")[1].toUpperCase(),style: TextStyle(fontSize: 16),)
                              ),
                            );
                          })
                          .toList(),
                      )
                    )
                  ),
                ],
              ),
            );
  }
}