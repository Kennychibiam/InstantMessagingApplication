import 'dart:math';

import "package:flutter/material.dart";

//import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<MaterialColor> avatarColors = [
    Colors.indigo,
    Colors.blueGrey,
    Colors.pink,
    Colors.orange
  ];

  // Future<List<Contact>> contacts = FlutterContacts.getContacts(sorted: true,withAccounts: true,withGroups: true,withProperties: true);
  Future<List<Contact>> contacts =
      ContactsService.getContacts(withThumbnails: false);
  Map<Contact,int>contactsMap={};
  @override
  void initState() {

    ContactsService.getContacts(withThumbnails: false).then((contactResult) async{
      contactResult.forEach((contactElement)async {
        var contactModel=await ContactDatabase().retrieveContactFromContactsTable(displayName: contactElement.displayName);
        int avatarColor=0;
        if(contactModel==null) {
          avatarColor= Random().nextInt(avatarColors.length);
          await insertToContactDatabase(contactElement.displayName, avatarColor);
          contactsMap[contactElement]=avatarColor;
        }
        else{
          contactsMap[contactElement]=contactModel.avatarColor!;


        }
        if(contactsMap.length==contactResult.length){
          setState(() {
          });
        }
      });

    }
    );

  }

  @override
  Widget build(BuildContext context) {

          return Scrollbar(
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: contactsMap.length,
                itemBuilder: (context, index) {
                  String? displayName = contactsMap.keys.elementAt(index).displayName;
                  return contactListTile(displayName,contactsMap[contactsMap.keys.elementAt(index)]??0);
                }),
          );
        }



  Widget contactListTile(String? displayName,int avatarColor) {
    return ListTile(
      //key: ValueKey(displayName),
      leading: CircleAvatar(
        backgroundColor: avatarColors[avatarColor],
        child: displayName?[0] != "*"
            ? Text(
          "${displayName?[0]}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
            : Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      title: Text("$displayName"),
      subtitle: Column(
        children: [
          SizedBox(height: 10.0),
          Divider(color: Colors.black45),
        ],
      ),
    );
  }

  Future insertToContactDatabase(String? displayName, int avatarColor) async {
    ContactsModel contactsModel =
        ContactsModel(displayName: displayName, avatarColor: avatarColor);
    await ContactDatabase()
        .insertIntoContactsTable(contactsModel: contactsModel);
  }


}
