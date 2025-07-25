import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase{
  static final LocalDatabase _instance = LocalDatabase._singleton();

  LocalDatabase._singleton();

   factory LocalDatabase(){
     return _instance;
   }

   static SharedPreferences? sharePrefs;

   Future<void> initSharedPref()async{
    try{
      sharePrefs = await SharedPreferences.getInstance();
    }catch(ex){
      debugPrint("Exception is occurred while initializing shared preferences $ex");
    }
}

  Future<void> saveBool({required String key, required bool value})async{
      sharePrefs!.setBool(key, value);
  }
}