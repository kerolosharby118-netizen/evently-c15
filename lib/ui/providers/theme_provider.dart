import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;


  changeMode(ThemeMode mode){
    this.mode = mode;
    notifyListeners();
  }
}