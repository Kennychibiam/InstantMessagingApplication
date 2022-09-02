

import 'package:flutter_sms/flutter_sms.dart';

class FlutterSmsClass{
  static FlutterSmsClass _flutterSendSmsClass=FlutterSmsClass.initialize();


  FlutterSmsClass.initialize();
  factory FlutterSmsClass(){
    return _flutterSendSmsClass;
  }

  Future<void> flutterSendSms(String message, List<String>recipients) async {
    String result=await sendSMS(message:message,recipients:recipients,sendDirect: true).catchError((onError){
      print("could not send sms");
    }
    );
    print(result);
  }
}
