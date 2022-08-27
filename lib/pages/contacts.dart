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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      contacts = ContactsService.getContacts(withThumbnails: false);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: contacts,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return Scrollbar(
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  String? displayName = snapshot.data?[index].displayName;
                  return contactListTile(displayName);
                }),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget contactListTile(String? displayName) {
    return ListTile(
      leading: FutureBuilder<ContactsModel?>(
        future: ContactDatabase()
            .retrieveColorFromContactsTable(displayName: displayName),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            int? color = snapshot.data?.avatarColor;
            return color != null
                ? CircleAvatar(
                    backgroundColor: avatarColors[color],
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
                  )
                : CircleAvatar(
                    backgroundColor: avatarColors[avatarColors.length - 1],
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
                  );
          }
          insertToContactDatabase(displayName);
          return CircleAvatar(
            backgroundColor: avatarColors[avatarColors.length - 1],
            child: displayName?[0] != "*"
                ? Text(
                    "${displayName?[0]}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
          );
        },
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

  void insertToContactDatabase(String? displayName) async {
    int avatarColor = Random().nextInt(avatarColors.length);
    ContactsModel contactsModel =
        ContactsModel(displayName: displayName, avatarColor: avatarColor);
    await ContactDatabase()
        .insertIntoContactsTable(contactsModel: contactsModel);
  }
}
