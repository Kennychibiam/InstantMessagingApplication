import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instant_message_me/providers/messages_contacts_provider.dart';

class BottomNavigationClass extends StatefulWidget {
  const BottomNavigationClass({Key? key}) : super(key: key);

  @override
  State<BottomNavigationClass> createState() => _BottomNavigationClassState();
}

class _BottomNavigationClassState extends State<BottomNavigationClass> {
  late MessagesContactsProvider messagesContactsProviderInstance;
  int currentBottomNavIndex=0;
  @override
  Widget build(BuildContext context) {
       messagesContactsProviderInstance=Provider.of<MessagesContactsProvider>(context,listen:false);
    return BottomNavigationBar(
     currentIndex:currentBottomNavIndex ,
      onTap: (index){
        currentBottomNavIndex=index;
        switch(index){
          case 0:
            messagesContactsProviderInstance.setCurrentNavigationIndex=index;
            break;
          case 1:
            messagesContactsProviderInstance.setCurrentNavigationIndex=index;
            break;
        }

      },
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedItemColor: Colors.black38,
      selectedItemColor: Color.fromARGB(255, 255, 218, 170),

      items: [
        BottomNavigationBarItem(
          label: "Messages",
          tooltip: "Messages",

          icon: messagesContactsProviderInstance.currentSelectedIndex==0
              ? Icon(
                  Icons.message,
                 // color: Colors.blue,
                )
              : Icon(Icons.message),
        ),
        BottomNavigationBarItem(
          label: "Contacts",
          tooltip: "Contacts",
          icon: messagesContactsProviderInstance.currentSelectedIndex==1
              ? Icon(
                  Icons.people_alt_rounded,
                 // color: Colors.blue,
                )
              : Icon(Icons.people_alt_rounded),
        ),
      ],
    );
  }
}
