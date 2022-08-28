import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/pages/messages.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:collection/collection.dart';
import '../colors.dart';

class SmsMessage extends StatefulWidget {
  String? contactName;
  int? avatarColor;

  SmsMessage({Key? key, required this.contactName, required this.avatarColor})
      : super(key: key);

  @override
  State<SmsMessage> createState() => _SmsMessageState();
}

class _SmsMessageState extends State<SmsMessage> {
  SmsQuery smsQuery = SmsQuery();
  List<dynamic> messagesList = [];
  var groupedMessagesList;
  int count=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAndInitializeMessages();
    initializeDateFormatting();
    LinkedHashMap linkedHashMap;
    // linkedHashMap.keys.length;
  }

  @override
  Widget build(BuildContext context) {
    String timeFormating= "";
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(

              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 251, 196, 144),
                Color.fromARGB(255, 228, 183, 160),
                //Color.fromARGB(255, 255, 239, 213)
              ],
            ),
          ),
        ),
      ),
      body: GroupedListView(
        primary: false,
        shrinkWrap: true,
        order: GroupedListOrder.ASC,
        //key: const PageStorageKey<String>("contacts"),

        //arranges elements in a group in asceneding order if item1 coms b4 item2
        itemComparator: (dynamic item1, dynamic item2)=>item1["date"].compareTo(item2["date"]),

        //value returned by groupBy is used to build the header using the groupSeparatorBuilder
        groupBy: (dynamic obj) => DateTime(
          obj["date"].year,
          obj["date"].month,
          obj["date"].day,


        ),

        elements: messagesList,
        groupSeparatorBuilder: (dynamic value) {
          return
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      DateFormat.yMMMd().format(value).replaceAll(",", ""),
                      style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
            );
        },
        itemBuilder: (context, dynamic element){


          return buildMessages(element["body"], element["kind"],element["avatarColor"],element["date"],element["canShowTime"]);
        },


      ),
    );
  }

  Widget buildMessages(String? body, SmsMessageKind? kind, int? avatarColor, DateTime time,bool canShowTime) {
    switch (kind) {
      case SmsMessageKind.Received:
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 40.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              canShowTime==true?(Text(DateFormat.Hm().format(time))):SizedBox(),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 183, 160),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(body ?? ""),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case SmsMessageKind.Sent:
        return Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 8.0, 10.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color.fromARGB(255, 251, 196, 144)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(body ?? ""),
                    ),
                  ),
                ),
              ),
              canShowTime==true?(Text(DateFormat.Hm().format(time))):SizedBox(),

            ],
          ),
        );

      case SmsMessageKind.Draft:
        return Align(
          alignment: Alignment.centerRight,
          child: DecoratedBox(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(body ?? ""),
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }

  void queryAndInitializeMessages() async {
    var messagesFromContact = await smsQuery.querySms(
      sort: true,

        address: widget.contactName,
        kinds: [SmsQueryKind.Sent, SmsQueryKind.Draft, SmsQueryKind.Inbox]);

    if (messagesFromContact.isNotEmpty) {
      messagesFromContact.sort((dynamic a,dynamic b)=>a["date"].compareTo(b["date"]));
      if (widget.avatarColor == null) {
        var contactModel = await ContactDatabase()
            .retrieveContactFromContactsTable(displayName: widget.contactName);
        widget.avatarColor = contactModel?.avatarColor;
      }
      String lastDateTime="";

      for (var message in messagesFromContact) {
        print(message.dateSent);
        bool canShowTime=true;
        if(messagesList.isNotEmpty && messagesList.last["date"]==message.dateSent){
          messagesList.last["canShowTime"]=false;
        }
        messagesList.add({
          "date": message.dateSent,
          "state": message.state, //sent, delivered, failed
          "body": message.body ?? "",
          "kind": message.kind,
          "canShowTime":canShowTime
        });
      }
    }
    setState(() {});
  }
}
