import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instant_message_me/colors.dart';
import 'package:instant_message_me/controllers/route_generator.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/models/contacts_model.dart';
import 'package:instant_message_me/providers/contacts_provider.dart';
import 'package:instant_message_me/providers/messages_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sms_advanced/contact.dart';
import 'package:sms_advanced/sms_advanced.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  late MessagesProvider messagesProvider;
  late ContactsProvider contactsProvider;
  late ScrollController groupListViewController=ScrollController();


  @override
  void initState() {



  }

  @override
  Widget build(BuildContext context) {
    messagesProvider=Provider.of<MessagesProvider>(context,listen:false);
    contactsProvider=Provider.of<ContactsProvider>(context,listen:false);
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
          physics: ScrollPhysics(),
          itemCount: messagesProvider.messagesContactList.length,
            itemBuilder: (context,index){
            String?address=messagesProvider.messagesContactList[index]["address"];
            String?fullName=messagesProvider.messagesContactList[index]["fullName"];
            int?avatarColor=messagesProvider.messagesContactList[index]["avatarColor"];
            int?unRead=messagesProvider.messagesContactList[index]["unRead"];
            String?lastMessage=messagesProvider.messagesContactList[index]["lastMessage"];
            DateTime?date=messagesProvider.messagesContactList[index]["date"];
              return Material(
                  child: InkWell(child: messagesListTile(address,fullName, avatarColor, lastMessage, date,unRead)));
            }

        ),
      ),
    );
  }


  Widget messagesListTile(String? address,String? fullName,int?avatarColor,String?lastMessage,DateTime? date, int? unRead) {
    return ListTile(
        onTap: ()async{
            var phoneNumbersList=await contactsProvider.queryContactListForPhoneNumbers(fullName??"");
            Navigator.pushNamed(context, RouteGenerator.SMS_PAGE,arguments: {"address":address,"fullName":fullName,"avatarColor":avatarColor,"phoneNumbers":phoneNumbersList});
        },
      //key: ValueKey(address),
      leading: CircleAvatar(
        backgroundColor: avatarColors[avatarColor??0],
        child: fullName?[0] != "*"
            ? Text(
          "${fullName?[0]}",
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
                child: Text("$fullName",maxLines: 1,)),
            Expanded(
                child: Text(DateFormat.MMMd().format(date!),maxLines: 1,textAlign: TextAlign.end)),
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


}
