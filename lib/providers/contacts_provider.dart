
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:instant_message_me/colors.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';
import 'package:provider/provider.dart';

class ContactsProvider extends ChangeNotifier{

  List< Map<dynamic,dynamic>>groupedContactList=[];
  int numberOfContacts=0;

  set setNumberOfContacts(int number) {
    numberOfContacts = number;
    notifyListeners();
  }
  Future queryAndInitializeContacts()async{
    ContactsService.getContacts(withThumbnails: false).then((contactResult) async{
      contactResult.forEach((contactElement)async {
        var contactModel=await ContactDatabase().retrieveContactFromContactsTable(displayName: contactElement.displayName);
        int avatarColor=0;
        if(contactModel==null) {
          avatarColor= Random().nextInt(avatarColors.length);
          await insertToContactDatabase(contactElement.displayName, avatarColor);
          groupedContactList.add({"name":contactElement.displayName,"value":contactElement,"avatarcolor":avatarColor});

        }
        else{
          groupedContactList.add({"name":contactElement.displayName,"value":contactElement,"avatarcolor":contactModel.avatarColor});



        }
        if(groupedContactList.length==contactResult.length){
          numberOfContacts=groupedContactList.length;
        }
      });

    }
    );
  }

  Future insertToContactDatabase(String? displayName, int avatarColor) async {
    ContactsModel contactsModel =
    ContactsModel(displayName: displayName, avatarColor: avatarColor);
    await ContactDatabase()
        .insertIntoContactsTable(contactsModel: contactsModel);
  }

  Future<List<Item> ?>queryContactListForPhoneNumbers(String contactNameFromMessagesPage)async{
    for(var contacts in groupedContactList){
      if(contacts["name"]==contactNameFromMessagesPage){
        return contacts["value"].phones;
      }
    }
  }



}