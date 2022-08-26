import "package:flutter/material.dart";

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String contactName="";

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }


Widget contactListTile(){
  return ListTile(leading: Container(),
            title: Text(),
           subtitle:Divider(),
    ,);
}
}
