import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier{
  String currentLocale = "en";

  void changeLanguage(String language){
    currentLocale = language;
    notifyListeners(); /// Use this instead of setState()
  }

}