import "package:flutter/material.dart";
//import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:contacts_service/contacts_service.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<MaterialColor>avatarColors=[Colors.indigo,Colors.blueGrey,Colors.pink,Colors.orange];
 // Future<List<Contact>> contacts = FlutterContacts.getContacts(sorted: true,withAccounts: true,withGroups: true,withProperties: true);
  Future<List<Contact>> contacts = ContactsService.getContacts(withThumbnails: false);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
        future:contacts,
        builder: (context,snapshot){
          if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
            return Scrollbar(
              child: ListView.builder(
                primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder:(context,index){
                    String ?contactName=snapshot.data?[index].displayName;
                return contactListTile(contactName);

              } ),
            );
          }
          return SizedBox();
        },
      );
  }


Widget contactListTile(String ?contactName){
  return ListTile(leading: Icon(Icons.person),
            title: Text("$contactName"),
           subtitle:Divider(),
    );
}
}
