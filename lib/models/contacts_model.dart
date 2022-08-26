import "dart:convert" as toJSONconverter;

import 'package:flutter/material.dart';

class ContactsModel {
  String? displayName;
  int? avatarColor;

  ContactsModel({this.displayName, required this.avatarColor});

  ContactsModel.toMap();

  Map<String, Object?> convertDataToMap() {
    return {"DISPLAY_NAME": displayName, "AVATAR_COLOR": avatarColor};
  }

  List<ContactsModel> fromJsonToContactsClass(
      List<Map<String, dynamic>>? queryResult) {
    //it can also be a type Object?
    return queryResult
        ?.map((e) => ContactsModel(
            displayName: e["DISPLAY_NAME"],
            avatarColor: e["AVATAR_COLOR"]))
        .toList()??[];
  }
}
