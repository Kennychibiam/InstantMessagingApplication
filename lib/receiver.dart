import 'package:sms_advanced/sms_advanced.dart';

class ReceiverClass {
  static ReceiverClass _receiverClass =ReceiverClass.initialize();
  static late SmsReceiver receiver = SmsReceiver();

  factory ReceiverClass(){
    return _receiverClass;
  }

  ReceiverClass.initialize();

  void receiverInitializeListenStream(){
    receiver.onSmsReceived?.listen(
            onError: (){print("dart could not start receiving stream");},
            (event) {
      print("dart recieved message");
    });
  }


}