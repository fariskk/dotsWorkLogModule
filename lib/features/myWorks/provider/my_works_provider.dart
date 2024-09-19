import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';

class MyWorksProvider extends ChangeNotifier {
  String? selectedWorkGroup;
  List<DateTime?> dateRangeToSort = [];
  String selectedTypeForSort = "All";
  String selectedPriorityForSort = "All";
  String selectedStatusForSort = "All";
  bool isFilterOn = false;
  DateTime? startDate;
  DateTime? endDate;
  String selectedPriority = "Mid";
  String? assignedBy;
  bool isSearchEnabled = false;
  String searchKeyword = "";

  String? client;
  double progressToUpdate = 0;
  List<Attachments> attachments = [];

  void rebuild() {
    notifyListeners();
  }

  Future<bool> submit(String workId, String taskName, String comments,
      String dependencies, BuildContext context) async {
    try {
      final fir = FirebaseFirestore.instance.collection("works");

      if (workId.isEmpty ||
          taskName.isEmpty ||
          startDate == null ||
          endDate == null ||
          assignedBy == null ||
          client == null ||
          selectedWorkGroup == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        Map<String, dynamic> newWork = {
          "id": workId,
          "type": "individual",
          "progress": 0,
          "client": client,
          "company": selectedWorkGroup,
          "createdDate": getDate(DateTime.now()),
          "taskName": taskName,
          "assignedBy": assignedBy,
          "startDate": getDate(startDate!),
          "endDate": getDate(endDate!),
          "priority": "$selectedPriority Priority",
          "status": "In Progress",
          "attachments": attachments.map((e) => e.toJson()).toList(),
          "comments": comments,
          "subWork": workId,
          "dependencies": dependencies,
        };

        await fir.doc(workId).set(newWork);

        FirebaseFirestore.instance.collection(workId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      mySnackBar("Somthing Went Wrong", context);
      return false;
    }
  }

  Future<bool> update(
      Works workToEdit,
      String workId,
      String taskName,
      String comments,
      String dependencies,
      BuildContext context,
      String reason) async {
    try {
      final fir = FirebaseFirestore.instance.collection("works");

      if (workId.isEmpty ||
          taskName.isEmpty ||
          startDate == null ||
          endDate == null ||
          assignedBy == null ||
          client == null ||
          selectedWorkGroup == null ||
          reason.isEmpty) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        String oldDocId = workToEdit.id;
        workToEdit.id = workId;
        workToEdit.progress = progressToUpdate.toInt();
        workToEdit.client = client!;
        workToEdit.company = selectedWorkGroup!;
        workToEdit.taskName = taskName;
        workToEdit.assignedBy = assignedBy!;
        workToEdit.startDate = getDate(startDate!);
        workToEdit.endDate = getDate(endDate!);
        workToEdit.attachments = attachments;
        workToEdit.priority = "$selectedPriority Priority";
        workToEdit.comments = comments;
        workToEdit.dependencies = dependencies;
        await fir.doc(oldDocId).delete();
        await fir.doc(workId).set(workToEdit.toJson());

        notifyListeners();
        return true;
      }
    } catch (e) {
      mySnackBar("Somthing Went Wrong", context);
      return false;
    }
  }

  void clear() {
    selectedTypeForSort = "All";
    selectedPriorityForSort = "All";
    selectedStatusForSort = "All";
    startDate = null;
    endDate = null;
    selectedPriority = "Mid";
    assignedBy = null;
    client = null;
    selectedWorkGroup = null;

    attachments.clear();
    progressToUpdate = 0;
  }
}
