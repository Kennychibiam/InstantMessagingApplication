import 'package:flutter/material.dart';
import 'package:instant_message_me/pages/contacts.dart';
import 'package:instant_message_me/pages/messages.dart';

class MessagesContactsProvider extends ChangeNotifier {
  int currentSelectedIndex = 0;
  List<Widget> messageContactsWidgetList = [Messages(), Contacts()];

  set setCurrentNavigationIndex(int index) {
    currentSelectedIndex = index;
    notifyListeners();
    print("notify");
  }
}
