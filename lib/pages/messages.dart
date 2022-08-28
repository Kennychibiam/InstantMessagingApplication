import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instant_message_me/colors.dart';
import 'package:instant_message_me/controllers/route_generator.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';
import 'package:sms_advanced/contact.dart';
import 'package:sms_advanced/sms_advanced.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  SmsQuery smsQuery = SmsQuery();
  //ContactQuery contactQuery = ContactQuery();
  List<dynamic> messagesContactList =
      []; //contains message threads that have the addresses"names" from messages



  @override
  void initState() {
    queryAndInitializeMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
      ),
      child: Scrollbar(
        interactive: true,
        child: ListView.builder(
          //key: const PageStorageKey<String>("messages"),
          primary: false,
          shrinkWrap: true,
          itemCount: messagesContactList.length,
            itemBuilder: (context,index){
            String?displayName=messagesContactList[index]["name"];
            int?avatarColor=messagesContactList[index]["avatarColor"];
            int?unRead=messagesContactList[index]["unRead"];
            String?lastMessage=messagesContactList[index]["lastMessage"];
            DateTime?date=messagesContactList[index]["date"];
              return Material(
                  child: InkWell(child: messagesListTile(displayName, avatarColor, lastMessage, date,unRead)));
            }

        ),
      ),
    );
  }


  Widget messagesListTile(String? displayName,int?avatarColor,String?lastMessage,DateTime? date, int? unRead) {
    return ListTile(
        onTap: (){
            Navigator.pushNamed(context, RouteGenerator.SMS_PAGE,arguments: {"contactName":displayName,"avatarColor":avatarColor});
        },
      //key: ValueKey(displayName),
      leading: CircleAvatar(
        backgroundColor: avatarColors[avatarColor??0],
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
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text("$displayName",maxLines: 1,)),
            Expanded(
                child: Text("${date?.hour}:${date?.minute}",maxLines: 1,textAlign: TextAlign.end)),
          ],
        ),
      ),
      subtitle: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child:
                  Text(lastMessage??"",maxLines: 2,)),
              Container(
                margin: EdgeInsets.all(3.0),
                child: unRead!=0?CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 10.0,
                  child: Text("${unRead}",style: TextStyle(fontSize:11.0,color: Colors.white),),
                ):SizedBox(width: 15.0,),
              )
            ],
          ),
          SizedBox(height: 10.0),
          Divider(color: Colors.black45),
        ],
      ),
    );
  }

  void queryAndInitializeMessages() async {
    var contactThreads = await smsQuery.getAllThreads;
    for (var threads in contactThreads) {
      var messagesFromContact =
      await smsQuery.querySms(address: threads.address);
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
          "name": threads.address,
          "unRead": numOfUnRead,
          "date": messagesFromContact.last.dateSent,
          "lastMessage": messagesFromContact.last.body,
          "avatarColor": avatarColor
        });
      }
      else {
        messagesContactList.add({
          "name": threads.address,
          "unRead": numOfUnRead,
          "date": messagesFromContact.last.dateSent,
          "lastMessage": messagesFromContact.last.body,
          "avatarColor": contactModel.avatarColor
        });
      }
    }




    }

    setState(() {

    });
  }

  Future insertToContactDatabase(String? displayName, int avatarColor) async {
    ContactsModel contactsModel =
    ContactsModel(displayName: displayName, avatarColor: avatarColor);
    await ContactDatabase()
        .insertIntoContactsTable(contactsModel: contactsModel);
  }
}
