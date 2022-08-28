
import 'package:flutter/material.dart';
import 'package:instant_message_me/main.dart';
import 'package:instant_message_me/pages/sms.dart';

class RouteGenerator{

  static const String MAIN_PAGE="MAIN_PAGE";
  static const String SMS_PAGE="SMS_PAGE";

  static Route<dynamic>routes(RouteSettings settings){
    switch(settings.name){
      case MAIN_PAGE:
        return MaterialPageRoute(builder: (context)=>MyApp());

      case SMS_PAGE:
        var args=settings.arguments as Map;
        return MaterialPageRoute(builder: (context)=>SmsMessage(contactName: args["contactName"], avatarColor: args["avatarColor"]));
      default:return MaterialPageRoute(builder: (context)=>MyApp());
    }

  }

}