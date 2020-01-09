import 'package:control_medico3/actions/treatmentActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CTreatment.dart';
import 'package:control_medico3/model/enumerations/MedicationType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'forms/new_treatment_form.dart';

enum CTreatmentMenuAction{ edit, delete }

class CTreatmentItem extends StatefulWidget{

  

  CTreatment treatment;


  CTreatmentItem(this.treatment,{Key key}) : super(key: key);

  @override
  _CTreatmentItemState createState() => _CTreatmentItemState();

}

class _CTreatmentItemState extends State<CTreatmentItem> {
  // ···
  

  @override
  void initState() {
    super.initState();

    
  }
  @override
  Widget build(BuildContext context) {

    
    
    initializeDateFormatting();
    var formatter=new DateFormat("dd/MM/yyyy","es");
    var formatterTime=new DateFormat("hh:mm a","es");
    String startDate=formatter.format(DateTime.fromMillisecondsSinceEpoch(widget.treatment.startDate.toInt()*1000));
    String endDate=formatter.format(DateTime.fromMillisecondsSinceEpoch(widget.treatment.endDate.toInt()*1000));
    String isPermanent= widget.treatment.isPermanent ? "Permanente,":startDate+" - "+endDate+", ";
    String timelapse=widget.treatment.configDosis.dosisTime.length.toString()+" dosis cada "+_parseTimelapse(widget.treatment.configDosis.frequencyDays);

    return 
           Container(
              padding: EdgeInsets.all(0.0),
              //height: 70,
              
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: .5,color: Color.fromRGBO(120, 120, 120, .3),style:BorderStyle.solid)),
                color:Colors.transparent
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(top:15,bottom: 15,left: 15,right:15),
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              
                              children: <Widget>[
                                Text(widget.treatment.medicationName,style: TextStyle(color: Colors.black,fontSize: 16)),
                                Divider(height: 5,color: Colors.transparent,),
                                Text(medicationTypetoString(widget.treatment.medicationType),style: TextStyle(color: Colors.black87,fontSize: 12)),
                                Divider(height: 5,color: Colors.transparent,),
                                Text(isPermanent+timelapse,style: TextStyle(color: Colors.black87,fontSize: 12))
                              ],
                            ),
                  ),
                  Container(
                    height: 85,
                    width: 30,
                    
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          height: 85,
                          width: 30,
                          
                          //top:10,
                          child:
                            Container(
                              width: 85,
                              height:30,
                              alignment: Alignment.topCenter,
                              child:_buildPopUpMenu() ,
                            ),
                          
                        ),
                      ],
                    ),
                  )
                  
                  
                ],
              )
            );
  }

  Widget _buildPopUpMenu(){
    
    return PopupMenuButton<CTreatmentMenuAction>(
      icon: Icon(Icons.more_vert),
      padding: EdgeInsets.all(0),
      
      onSelected: (CTreatmentMenuAction result) async { 
        switch(result){
          case CTreatmentMenuAction.delete:
            StoreProvider.of<AppState>(context).dispatch(DeleteTreatmentAction(widget.treatment));
          ;break;
          case CTreatmentMenuAction.edit:
            StoreProvider.of<AppState>(context).dispatch(InitFormEditTreatmentAction(widget.treatment));
            final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => NewTreatmentForm(edition: true,)),);
            StoreProvider.of<AppState>(context).dispatch(LoadTreatmentsAction());
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CTreatmentMenuAction>>[
        const PopupMenuItem<CTreatmentMenuAction>(
          value: CTreatmentMenuAction.edit,
          child: Text('Editar'),
        ),
        const PopupMenuItem<CTreatmentMenuAction>(
          value: CTreatmentMenuAction.delete,
          child: Text('Eliminar'),
        ),
        
      ],
    );
  }

  String _parseTimelapse(int days){
    if(days<7){
      return days.toString()+" dias";
    }else{
      int semanas=days~/7;
      return semanas.toString()+" semanas";
    }
  }
}