import 'package:control_medico3/model/CDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateItem extends StatefulWidget{

  int index;
  
  CDate date;


  DateItem(this.date,{Key key}) : super(key: key);

  @override
  _DateItemState createState() => _DateItemState();

}

class _DateItemState extends State<DateItem> {
  // ···
  bool selected;

  @override
  void initState() {
    super.initState();

    selected = false;
  }
  @override
  Widget build(BuildContext context) {

    initializeDateFormatting();
    var formatter=new DateFormat("d MMM yyyy","es");
    var formatterTime=new DateFormat("HH:mm","es");
    return GestureDetector(
      onLongPress: (){ 
        setState(() {
          selected=!selected;
        }); 
      },
      child: Container(
              padding: EdgeInsets.all(0.0),
              //height: 70,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: .5,color: Color.fromRGBO(120, 120, 120, .3),style:BorderStyle.solid)),
                color:selected ? Theme.of(context).primaryColor.withOpacity(.2):Colors.transparent,
              ),
              child: Row(
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
                                Text(formatterTime.format(widget.date.getTime),style: TextStyle(color: Colors.black87,fontSize: 12))
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
                  )
                  
                ],
              )
            )
    );
  }
}