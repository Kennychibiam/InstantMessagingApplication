
import 'package:flutter/material.dart';
import 'package:instant_message_me/main.dart';

class RouteGenerator{

  static const String MAIN_PAGE="MAIN_PAGE";
  static Route<dynamic>routes(RouteSettings settings){
    switch(settings.name){
      case MAIN_PAGE:
        return MaterialPageRoute(builder: (context)=>MyApp());
      default:return MaterialPageRoute(builder: (context)=>MyApp());
    }

  }

}