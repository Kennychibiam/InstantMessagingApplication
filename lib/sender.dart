import 'package:sms_advanced/sms_advanced.dart';

class SenderClass {
  static SenderClass _senderClass = SenderClass.initialize();
  static late SmsSender sender = SmsSender();

  factory SenderClass(){
    return _senderClass;
  }

  SenderClass.initialize();

  void sendSmS(SmsMessage message, SimCard simcard) {
    message.onStateChanged.listen((state) {
      switch (state) {
        case SmsMessageState.Sent:
          print("sent"); //put setstate here
          break;
        case SmsMessageState.Fail:
          print("failed");
          break;
      }
    }
  );
  sender.sendSms(message, simCard: simcard);
}

}