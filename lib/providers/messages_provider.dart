
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:instant_message_me/colors.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';
import 'package:sms_advanced/sms_advanced.dart';

class MessagesProvider extends ChangeNotifier{


//ContactQuery contactQuery = ContactQuery();
  //contains message threads that have the addresses"names" from messages

  SmsQuery smsQuery = SmsQuery();

  List<dynamic> messagesContactList =
  [];


  Future queryAndInitializeMessages() async {
    var contactThreads = await smsQuery.getAllThreads;

    for (var threads in contactThreads) {

      var messagesFromContact =
      await smsQuery.querySms(address: threads.address,kinds: [SmsQueryKind.Inbox,SmsQueryKind.Sent,SmsQueryKind.Draft]);
      int numOfUnRead = 0;
      for (var message in messagesFromContact) {
        if (message != null && !message.isRead!) {
          numOfUnRead += 1;
        }
      }

      if (messagesFromContact.isNotEmpty){
        var contactModel = await ContactDatabase()
            .retrieveContactFromContactsTable(displayName: threads.address);
        int avatarColor = 0;
        if (contactModel == null) {
          avatarColor = Random().nextInt(avatarColors.length);
          await insertToContactDatabase(threads.address, avatarColor);
          messagesContactList.add({
            "fullName": threads.contact?.fullName??threads.address,//for display in list
            "address":threads.address,//for querying messages
            "unRead": numOfUnRead,
            "date": messagesFromContact.first.date?? messagesFromContact.first.dateSent,
            "lastMessage": messagesFromContact.first.body,
            "avatarColor": avatarColor,

          });
        }
        else {
          messagesContactList.add({
            "fullName": threads.contact?.fullName??threads.address,//for display in list
            "address":threads.address,//for querying messages
            "unRead": numOfUnRead,
            "date": messagesFromContact.first.date?? messagesFromContact.first.dateSent,
            "lastMessage": messagesFromContact.first.body,
            "avatarColor": contactModel.avatarColor
          });
        }
      }




    }
           notifyListeners();

  }

  Future insertToContactDatabase(String? displayName, int avatarColor) async {
    ContactsModel contactsModel =
    ContactsModel(displayName: displayName, avatarColor: avatarColor);
    await ContactDatabase()
        .insertIntoContactsTable(contactsModel: contactsModel);
  }

}