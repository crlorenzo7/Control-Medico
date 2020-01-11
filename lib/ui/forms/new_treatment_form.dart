import 'dart:async';

import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/FormAddTreatmentState.dart';
import 'package:control_medico3/model/enumerations/CEventType.dart';
import 'package:control_medico3/repository/CTreatmentRepository.dart';
import 'package:control_medico3/ui/forms/new_treatment/newTreatmentStepOne.dart';
import 'package:control_medico3/ui/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

import 'new_treatment/newTreatmentStepThree.dart';
import 'new_treatment/newTreatmentStepTwo.dart';


class NewTreatmentForm extends StatefulWidget{
  
  bool edition=false;

  NewTreatmentForm({this.edition=false});

  @override
  _NewTreatmentFormState createState() => _NewTreatmentFormState();

}

class _NewTreatmentFormState extends State<NewTreatmentForm>{
  final _formKey = GlobalKey<FormState>();
  int _formState=0;
  int currentStep=0;
  Map<String,dynamic> formData=new Map();
  void fixState(int state) {
    // reload
    setState(() {
      _formState = state;
    });
  }

  @override
  void dispose(){
    super.dispose();
    //_timer.cancel();
  }
  
  @override
  Widget build(BuildContext context) {
    formData["type"]=CEventType.date.index;
    
    initializeDateFormatting();
    var formatter=new DateFormat("d 'de' MMMM 'de' yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    
    return Scaffold(
              appBar: AppBar(
                title: Text("Nuevo tratamiento",style: TextStyle(fontWeight: FontWeight.normal),textAlign: TextAlign.center),
              ),
              body:Builder(
                builder:(context){
                  return StoreConnector<AppState,FormAddTreatmentState>(
                    distinct: true,
                    converter: (Store<AppState> store) => store.state.formAddTreatment,
                    builder: (context,state){
                      return state.treatment!=null ? _buildStepper() : Loader();
                    },
                  );
                  
                }
              )
          );
            
           
  }

  Widget _buildStepper(){
    var width=MediaQuery.of(context).size.width-200;
    var stepWidth=(width/4);
    return Container(
        decoration: BoxDecoration(
          color:Colors.white
        ),
        child:Stepper(
          physics: ClampingScrollPhysics(),
          controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}){
                      return Container(height: 0,width: 0,);
                    }    
          ,
          onStepTapped: (int index){
            
          },
          onStepContinue: (){ 
            if(currentStep<2){
              setState((){currentStep++;});
            }
          },
          onStepCancel: (){
            if(currentStep>0){
              setState((){currentStep--;});
            }
          },
          currentStep: currentStep,
          type: StepperType.horizontal,
          
          steps: [
            Step(
              title: Text(""),
              content: NewTreatmentStepOne(onContinue: (formData){
                if(widget.edition){
                  StoreProvider.of<AppState>(context).dispatch(UpdateTreatmentSubmitStepOne(formData));
                }else{
                  CTreatment treatment = CTreatment.fromMap(formData);
                  StoreProvider.of<AppState>(context).dispatch(AddTreatmentSubmitStepOne(treatment));
                }
                setState((){currentStep++;});
              }),
              isActive: currentStep==0
            ),
            Step(
              title: Text(""),
              content: NewTreatmentStepTwo(onContinue: (CTreatment treatment){
                if(widget.edition){
                  StoreProvider.of<AppState>(context).dispatch(UpdateTreatmentSubmitStepTwo(treatment));
                }else{
                  StoreProvider.of<AppState>(context).dispatch(AddTreatmentSubmitStepTwo(treatment));
                }
                setState((){currentStep++;});
              },onGoBack: (){
                setState(() {
                  currentStep--;
                });
              },),
              isActive: currentStep==1
            ),
            Step(
              title: Text(""),
              content: NewTreatmentStepThree(onContinue: (CTreatment treatment) async{
                if(widget.edition){
                  StoreProvider.of<AppState>(context).dispatch(UpdateTreatmentAction(treatment));
                }else{
                  StoreProvider.of<AppState>(context).dispatch(AddTreatmentAction(treatment));
                }
                _showDialog();
                //Navigator.of(context).pop();
                //setState((){currentStep++;});
              },onGoBack: (){
                setState(() {
                  currentStep--;
                });
              },),
              isActive: currentStep==2
            ),
            
          ],
        ) ,
      );

  }

  Future<bool> _showDialog() async {
    // flutter defined function

    Widget _buildLoaderDialog(){
      return AlertDialog(
          title: Text("Añadir Tratamiento"),
          content: Container(
            height: 100,
            child:Center(
              child: CircularProgressIndicator()
            )
          )
          
        );
    }

    Widget _buildSuccessDialog(){
      return AlertDialog(
          title: Text("Tratamiento añadido"),
          content: Text("Tratamiento añadido con exito"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(

              child: new Text("ACEPTAR"),
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
    
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Builder(
                builder:(context){
                  return StoreConnector<AppState,FormAddTreatmentState>(
                    distinct: true,
                    converter: (Store<AppState> store) => store.state.formAddTreatment,
                    builder: (context,state){
                      if(state.isProcessing){
                        return _buildLoaderDialog();
                      }
                      if(state.success){
                        return _buildSuccessDialog();
                      }
                      return Container();
                    },
                  );
                  
                }
              ); 
      },
    );
    Navigator.of(context).pop();
  }

}


