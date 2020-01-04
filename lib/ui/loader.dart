import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget{

 
  Loader();

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children:<Widget>[
        Expanded(
          child: Center(
            child: CircularProgressIndicator()
          )
        )
      ]
    );
  }

}