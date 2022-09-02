import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:instant_message_me/classes/flutter_send_sms.dart';
import 'package:instant_message_me/databases/contacts_database.dart';
import 'package:instant_message_me/pages/messages.dart';
import 'package:instant_message_me/sender.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:collection/collection.dart';
import '../colors.dart';

class SmsMessagePage extends StatefulWidget {
  String? address;
  String? fullName;
  int? avatarColor;
  List<Item>? phoneNumber;

  SmsMessagePage({
    Key? key,
    required this.address,
    required this.fullName,
    required this.avatarColor,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SmsMessagePage> createState() => _SmsMessageState();
}

class _SmsMessageState extends State<SmsMessagePage> {
  SmsQuery smsQuery = SmsQuery();
  List<dynamic> messagesList = [];
  int count = 0;
  bool isPhoneNumbersEmpty = true;
  double heightOfScreen = 0.0;
  late ScrollController smsScrollController = ScrollController();
  late SimCardsProvider simCardProvider=SimCardsProvider();
  late TextEditingController messageController=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    queryAndInitializeMessages();
    initializeDateFormatting();
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      isPhoneNumbersEmpty = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    heightOfScreen = MediaQuery.of(context).size.height;
    String timeFormating = "";
    return Scaffold(
      appBar: AppBar(
        title: !isPhoneNumbersEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullName ?? "",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    widget.phoneNumber![0].value ?? "",
                    style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ],
              )
            : Text(widget.fullName ?? "",
                style: TextStyle(color: Colors.black54)),
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
      body: Column(
        children: [
          Expanded(
            child: GroupedListView(
              primary: false,
              order: GroupedListOrder.ASC,
              controller: smsScrollController,
              //key: const PageStorageKey<String>("contacts"),

              //arranges elements in a group in asceneding order if item1 coms b4 item2
              itemComparator: (dynamic item1, dynamic item2) =>
                  item1["date"].compareTo(item2["date"]),

              //value returned by groupBy is used to build the header using the groupSeparatorBuilder
              groupBy: (dynamic obj) => DateTime(
                obj["date"].year,
                obj["date"].month,
                obj["date"].day,
              ),

              elements: messagesList,
              groupSeparatorBuilder: (dynamic value) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                          DateFormat.yMMMd().format(value).replaceAll(",", ""),
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                );
              },
              itemBuilder: (context, dynamic element) {
                return buildMessages(element["body"], element["kind"],
                    element["avatarColor"], element["date"], element["canShowTime"]);
              },
            ),
          ),
          smsTextField(),
        ],
      ),
    );
  }

  Widget buildMessages(String? body, SmsMessageKind? kind, int? avatarColor,
      DateTime time, bool canShowTime) {
    switch (kind) {
      case SmsMessageKind.Received:
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 40.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Visibility(
                  visible: canShowTime,
                  replacement: Text("          "),
                  child: Text(DateFormat.Hm().format(time))),
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
              Visibility(
                  visible: canShowTime,
                  replacement: Text("          "),
                  child: Text(DateFormat.Hm().format(time))),
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


  Widget smsTextField(){
    return !isPhoneNumbersEmpty?Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12.0),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: TextField(
            maxLines: null,
            controller: messageController,
            keyboardType:TextInputType.multiline,
            decoration:InputDecoration(border: InputBorder.none),
          )),
          FutureBuilder<List<SimCard>>(
              future: simCardProvider.getSimCards(),
              builder: (context,snapshot){
                if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
                  List<Widget>simCardWidgetList=[];
                  int i=0;
                for(var simcard in snapshot.data! ){
                  simCardWidgetList.add(buildSimCards(i,simcard));
                  ++i;
                }
                return Row(children: [...simCardWidgetList],);
                }
                return SizedBox();
              }),

        ],
      ),
    ):SizedBox();
  }

  Widget buildSimCards(int index,SimCard simCard){
    int incrIndex=index+1;
    return InkWell(
      onTap: (){
        if(messageController.text.toString().isNotEmpty){
          print(messageController.text.toString());
          print(widget.fullName);
          print(simCard.state.toString());
            List<String>phoneNumbers=[widget.phoneNumber![0].value??""];
            FlutterSmsClass().flutterSendSms(messageController.text.toString(),phoneNumbers);
           }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 18.0,
          backgroundColor: Color.fromARGB(255, 192, 192, 192),
          child: Stack(children: [
            Center(child: Icon(Icons.send,color: simCardColors[index],)),
            Align(
              alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                    radius: 8.0,
                    child: Text(incrIndex.toString(),style: TextStyle(color: Colors.white),))),


          ],),
        ),
      ),
    );
  }

  void queryAndInitializeMessages() async {
    var messagesFromContact = await smsQuery.querySms(
        sort: true,
        address: widget.address,
        kinds: [SmsQueryKind.Sent, SmsQueryKind.Draft, SmsQueryKind.Inbox]);

    if (messagesFromContact.isNotEmpty) {
      messagesFromContact
          .sort((dynamic a, dynamic b) => a.dateSent.compareTo(b.dateSent));
      if (widget.avatarColor == null) {
        var contactModel = await ContactDatabase()
            .retrieveContactFromContactsTable(displayName: widget.address);
        widget.avatarColor = contactModel?.avatarColor;
      }

      for (var message in messagesFromContact) {
        message.isRead != true;
        bool canShowTime = true;
        if (messagesList.isNotEmpty &&
            messagesList.last["date"] == message.date) {
          messagesList.last["canShowTime"] = false;
        }
        messagesList.add({
          "date": message.date??message.dateSent,
          "state": message.state, //sent, delivered, failed
          "body": message.body ?? "",
          "kind": message.kind,
          "canShowTime": canShowTime
        });
      }
    }
    await Timer(
      Duration(milliseconds: 20),
      () => smsScrollController.jumpTo(
          smsScrollController.position.maxScrollExtent *
              heightOfScreen *
              messagesFromContact.length),
    );
    // () => smsScrollController.animateTo(
    //     smsScrollController.position.maxScrollExtent *
    //         heightOfScreen *
    //         messagesFromContact.length*1.5,
    //     duration: Duration(milliseconds: 50),
    //     curve: Curves.easeOut)

    setState(() {
      //smsScrollController.jumpTo(smsScrollController.position.maxScrollExtent);
      //smsScrollController.animateTo(smsScrollController.position.minScrollExtent, duration:Duration(milliseconds: 550), curve:Curves.easeOut);
    });
  }
}
