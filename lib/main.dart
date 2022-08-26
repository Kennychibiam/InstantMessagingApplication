import 'package:flutter/material.dart';
import 'package:instant_message_me/provider/messages_contacts_provider.dart';
import 'package:provider/provider.dart';

void main() {
  MessagesContactsProvider messagesProviderInstance=MessagesContactsProvider();

  runApp(MultiProvider(
    providers: [
      Provider<MessagesContactsProvider>(

          create:(_)=> messagesProviderInstance),
    ],
      child: const MaterialApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{return true;},
        child:Consumer<MessagesContactsProvider>(
             builder: (context,messageProviderInstance,child)=>,
        ) ) ;
  }
}
