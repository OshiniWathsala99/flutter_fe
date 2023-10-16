import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String userName;

  User({required this.userName});

  void updateUserName(String newUserName) {
    userName = newUserName;
    notifyListeners(); // Notify listeners when the user name changes
  }
}