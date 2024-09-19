import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  Locale language = const Locale("en");
  List<String> companyes = [
    "Dots Hr",
    "G Force",
    "V-Tech",
    "Oracle",
    "Microsoft",
    "Apple"
  ];
  List<String> employees = [
    "Faris kk",
    "Fasal pk gchgkcgc vhgchgchkgchc hgchchc chcy",
    "Sahas Rk",
    "Abay",
    "Safiyya p",
    "Shukur kk"
  ];
  List<String> clients = ["V-Tech", "Dots Hr", "Oracle", "G Force"];
  List<String> workTitle = ["Testing", "UI Design", "Backend", "Bug Fix"];
  void rebuild() {
    notifyListeners();
  }
}
