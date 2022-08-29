import 'dart:math';

import "package:flutter/material.dart";

//import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:instant_message_me/colors.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';
import 'package:collection/collection.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:instant_message_me/providers/contacts_provider.dart';
import 'package:instant_message_me/providers/messages_contacts_provider.dart';
import 'package:provider/provider.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {



  //contains the list of maps:key is the first display name value is the contact element
  late MessagesContactsProvider messagesContactsProvider;
  late ContactsProvider contactsProvider;
  @override
  void initState() {


  }

  @override
  Widget build(BuildContext context) {
    contactsProvider=Provider.of<ContactsProvider>(context,listen: false);

          return Container(
            decoration:BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
            ),
            child: Scrollbar(
              interactive: true,

              child: GroupedListView(
                  primary: false,
                  shrinkWrap: true,
                physics: ScrollPhysics(),


                //key: const PageStorageKey<String>("contacts"),

                //arranges elements in a group in asceneding order if item1 coms b4 item2
                itemComparator: (dynamic item1, dynamic item2)=>item1["name"].compareTo(item2["name"]),

                //value returned by groupBy is used to build the header using the groupSeparatorBuilder

                groupSeparatorBuilder: (dynamic value)=>Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value,style: TextStyle(fontSize:18.0,fontWeight: FontWeight.bold)),
                  ),
                  itemBuilder: (context, dynamic element) {

                    //String? displayName = contactsMap.keys.elementAt(index).displayName;
                    return contactListTile(element["name"],element["avatarcolor"]);
                  },

                groupBy: (dynamic obj)=>obj["name"].toUpperCase().substring(0,1),

                elements: contactsProvider.groupedContactList,
                order: GroupedListOrder.ASC,
              ),
            ),
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




}
