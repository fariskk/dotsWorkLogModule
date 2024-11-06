import 'package:dots_ticcket_module/models/models.dart';
import 'package:flutter/material.dart';

class WorklogProvider extends ChangeNotifier {
  String selectedStatus = "In Progress";
  String? assignTo;
  List<Attachments> attachments = [];
  List statusTypes = [
    "In Progress",
    "Assign To",
    "Completed",
  ];

  void rebuild() {
    notifyListeners();
  }

  void clear() {
    selectedStatus = "In Progress";
    assignTo = null;
    attachments = [];
  }
}
