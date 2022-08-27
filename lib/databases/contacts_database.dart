import 'dart:io';

import 'package:instant_message_me/models/contacts_model.dart';
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";
import 'package:path/path.dart';

class ContactDatabase {
  static ContactDatabase _instance = ContactDatabase.initializeContactDatabase();
  static Database? database;
  static const String CONTACTS_TABLE = "CONTACTS_TABLE";
  //static const String NOTIFICATION_TABLE = "NOTIFICATION_TABLE";

  factory ContactDatabase(){
    return _instance;
  }
  ContactDatabase.initializeContactDatabase();

  //gets the instance of the Database if database object is null
  Future<Database> get openGetDatabase async {
    return database ?? await createOrOpenTableDatabase();
  }

  Future<Database> createOrOpenTableDatabase() async {
    Directory path = Platform.isIOS
        ? await getLibraryDirectory()
        : await getApplicationDocumentsDirectory();
    ;
    return openDatabase(
      join(path.path, 'example.db'),

      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE CONTACTS_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT,"
              " DISPLAY_NAME TEXT NOT NULL, "
              "AVATAR_COLOR INTEGER NOT NULL"
              
              ")",
        );
        //await database.execute("CREATE TABLE NOTIFICATION_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT NOT NULL, DATE TEXT NOT NULL, TIME TEXT NOT NULL )");
      },
      version: 1,
    );
  }

  Future<int?> insertIntoContactsTable(
      {required ContactsModel contactsModel}) async {
    int? result;

    database =
    await _instance.openGetDatabase; //returns instance of itself if not null

    List<Map<String, Object?>>? resultCheck = await database
        ?.query(CONTACTS_TABLE, where: "DISPLAY_NAME=?", whereArgs: [contactsModel.displayName]);

    if (resultCheck?.isNotEmpty ?? false) {
      result = await updateContactsTable(
          tableName: CONTACTS_TABLE, contactsModel: contactsModel);
    } else {
      result =
      await database?.insert(CONTACTS_TABLE, contactsModel.convertDataToMap());
    }
    return result;
  }


  Future<List<ContactsModel>> retrieveFromContactsTable({required String tableName}) async {
    database =
    await _instance.openGetDatabase; //returns instance of itself if not null

    List<Map<String, Object?>>? result = await database?.query(tableName);
    return ContactsModel.toMap().fromJsonToContactsClass(result);
  }

  Future<int?> updateContactsTable(
      {required String tableName, required ContactsModel contactsModel}) async {
    int? result;
    database = await _instance.openGetDatabase;

    result = await database?.update(tableName, contactsModel.convertDataToMap(),
        where: "DISPLAY_NAME=?", whereArgs: [contactsModel.displayName]);
    //print(result??""+ "  update");
    return result;
  }

  Future<int?> removeFromDatabase(String tableName, String? listTitle) async {
    int? result;
    database = await _instance.openGetDatabase;
    result = await database
        ?.delete(tableName, where: "DISPLAY_NAME=?", whereArgs: [listTitle]);
    return result;
  }


  Future<ContactsModel?> retrieveColorFromContactsTable({required String ? displayName}) async {
    database =
    await _instance.openGetDatabase; //returns instance of itself if not null

    List<Map<String, Object?>>? result = await database?.query(CONTACTS_TABLE,where: "DISPLAY_NAME=?",whereArgs: [displayName]);

    if(result!=null){
      return ContactsModel.toMap().fromJsonToContactsClass(result).first;
    }
    return null;
  }

}
