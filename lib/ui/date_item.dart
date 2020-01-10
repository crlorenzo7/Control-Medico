import 'package:control_medico3/actions/dateActions.dart';
import 'package:control_medico3/model/AppState.dart';
import 'package:control_medico3/model/CDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'forms/new_date_form.dart';


enum CDateMenuAction{ edit, delete }

class DateItem extends StatefulWidget{

  
  bool options=false;
  CDate date;


  DateItem(this.date,this.options,{Key key}) : super(key: key);

  @override
  _DateItemState createState() => _DateItemState();

}

class _DateItemState extends State<DateItem> {
  // ···
  

  @override
  void initState() {
    super.initState();

    
  }
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    if(widget.options){
      width -= 30;
    }
    
    initializeDateFormatting();
    var formatter=new DateFormat("d MMM yyyy","es");
    var formatterTime=new DateFormat("HH:mm a","es");
    return GestureDetector(
      onLongPress: (){ 
        
      },
      child: Container(
              padding: EdgeInsets.all(0.0),
              //height: 70,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: .5,color: Color.fromRGBO(120, 120, 120, .3),style:BorderStyle.solid)),
                color:Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                  Container(
                    width: width,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:EdgeInsets.only(top:15,bottom: 15,left: 15,right:15),
                          child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: <Widget>[
                                      Text(formatter.format(widget.date.getDay),style: TextStyle(color: Colors.black87,fontSize: 12)),
                                      Divider(height: 5,color: Colors.transparent,),
                                      Text(widget.date.title,style: TextStyle(color: Colors.black,fontSize: 16)),
                                      Divider(height: 5,color: Colors.transparent,),
                                      Text(formatterTime.format(widget.date.getTime).toUpperCase(),style: TextStyle(color: Colors.black87,fontSize: 12))
                                    ],
                                  ),
                        ),
                        InkWell(
                          
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(1000),
                              boxShadow: [BoxShadow(offset: Offset(0, 0),blurRadius: 0)]
                              
                            ),
                            child:Icon(Icons.my_location,color: Colors.black,size: 18,)
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Builder(
                    builder: (context){
                      return widget.options ?
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
                        :Container(width: 0,height: 0,);
                      
                    },
                  )
                  
                  
                  
                ],
                
              )
            )
    );
  }

  Widget _buildPopUpMenu(){
    
    return PopupMenuButton<CDateMenuAction>(
      icon: Icon(Icons.more_vert),
      padding: EdgeInsets.all(0),
      
      onSelected: (CDateMenuAction result) async { 
        switch(result){
          case CDateMenuAction.delete:
            StoreProvider.of<AppState>(context).dispatch(DeleteDateAction(widget.date));
          ;break;
          case CDateMenuAction.edit:
            StoreProvider.of<AppState>(context).dispatch(InitFormUpdateDateAction(widget.date));
            final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => NewDateForm(edition: true,)),);
            StoreProvider.of<AppState>(context).dispatch(LoadDatesAction());
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CDateMenuAction>>[
        const PopupMenuItem<CDateMenuAction>(
          value: CDateMenuAction.edit,
          child: Text('Editar'),
        ),
        const PopupMenuItem<CDateMenuAction>(
          value: CDateMenuAction.delete,
          child: Text('Eliminar'),
        ),
        
      ],
    );
  }
}