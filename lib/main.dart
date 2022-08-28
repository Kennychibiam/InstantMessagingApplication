import 'package:flutter/material.dart';
import 'package:instant_message_me/bottom_navigation.dart';
import 'package:instant_message_me/controllers/route_generator.dart';
import 'package:instant_message_me/providers/messages_contacts_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MessagesContactsProvider messagesProviderInstance =
      MessagesContactsProvider();
  var status = await Permission.contacts.request();
  if (status.isGranted) {
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<MessagesContactsProvider>(
              create: (_) => messagesProviderInstance)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteGenerator.MAIN_PAGE,
          onGenerateRoute: RouteGenerator.routes,
        )));
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Consumer<MessagesContactsProvider>(
          builder: (context, messageProviderInstance, child) =>
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 251, 196, 144),

                      //Color.fromARGB(255, 255, 218, 185),
                      Color.fromARGB(255, 255, 239, 213)
                    ],
                  ),
                ),
                child: Scaffold(
            backgroundColor:Colors.transparent,
            body: CustomScrollView(
              shrinkWrap: true,

                slivers: [
                  SliverAppBar(
                    elevation: 0.0,
                    expandedHeight: 200.0,
                    pinned: true,
                    flexibleSpace: Container(
                      //adds gradient colors
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 251, 196, 144),
                            Color.fromARGB(255, 255, 239, 213)
                          ],
                        ),
                      ),

                      child: messageProviderInstance.currentSelectedIndex == 0
                          ? Center(
                            child: Text(
                                "Messages",
                                style: TextStyle(color: Colors.black26,fontSize: 30.0),
                              ),
                          )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Contacts",
                                  style: TextStyle(color: Colors.black26,fontSize: 30.0),
                                ),
                              Text(
                                "${messageProviderInstance.numberOfContacts}",
                                style: TextStyle(color: Colors.black26,fontSize: 18.0),
                              ),
                            ],
                          ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: IndexedStack(
                      index: messageProviderInstance.currentSelectedIndex,
                      children: [
                        ...messageProviderInstance.messageContactsWidgetList,
                      ],
                    ),
                  ),
                ],
            ),
            bottomNavigationBar: BottomNavigationClass(),
          ),
              ),
        ));
  }
}
