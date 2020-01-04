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
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';

import 'new_treatment/newTreatmentStepThree.dart';
import 'new_treatment/newTreatmentStepTwo.dart';


class NewTreatmentForm extends StatefulWidget{
  

  NewTreatmentForm();

  @override
  _NewTreatmentFormState createState() => _NewTreatmentFormState();

}

class _NewTreatmentFormState extends State<NewTreatmentForm>{
  final _formKey = GlobalKey<FormState>();
  int _formState=0;
  Timer _timer;
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
    return Container(
        decoration: BoxDecoration(
          color:Colors.white
        ),
        child:Stepper(
          controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}){
                      return Container(height: 0,width: 0,);
                    }    
          ,
          onStepTapped: (int index){
            setState(() {
              currentStep=index;
            });
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
              title: Text("Datos"),
              content: NewTreatmentStepOne(onContinue: (CTreatment treatment){
                StoreProvider.of<AppState>(context).dispatch(AddTreatmentSubmitStepOne(treatment));
                setState((){currentStep++;});
              }),
              isActive: currentStep==0
            ),
            Step(
              title: Text("Administracion"),
              content: NewTreatmentStepTwo(onContinue: (CTreatment treatment){
                StoreProvider.of<AppState>(context).dispatch(AddTreatmentSubmitStepTwo(treatment));
                setState((){currentStep++;});
              },onGoBack: (){
                setState(() {
                  currentStep--;
                });
              },),
              isActive: currentStep==1
            ),
            Step(
              title: Text("dosis"),
              content: NewTreatmentStepThree(onContinue: (CTreatment treatment){
                _showDialog();
                StoreProvider.of<AppState>(context).dispatch(AddTreatmentAction(treatment));

                //setState((){currentStep++;});
              },onGoBack: (){
                setState(() {
                  currentStep--;
                });
              },),
              isActive: currentStep==2
            )
          ],
        ) ,
      );

  }

  void _showDialog() {
    // flutter defined function

    Widget _buildLoaderDialog(){
      return AlertDialog(
          title: Text("Añadir Tratamiento"),
          content: Loader(),
          
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

    showDialog(
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
  }

}


