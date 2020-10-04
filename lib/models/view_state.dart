import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  DateTime cuurentDateTime = DateTime.now();

  prevMonth() {
    cuurentDateTime = DateTime(cuurentDateTime.year, cuurentDateTime.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    cuurentDateTime = DateTime(cuurentDateTime.year, cuurentDateTime.month + 1);
    notifyListeners();
  }

}
