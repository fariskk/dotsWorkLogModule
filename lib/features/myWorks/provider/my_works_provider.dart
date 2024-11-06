import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/models/models.dart';
import 'package:dots_ticcket_module/services/api_services.dart';
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
  bool isLoading = false;
  String? client;
  double progressToUpdate = 0;
  List<Attachments> attachments = [];

  void rebuild() {
    notifyListeners();
  }

  Future<bool> submit(String taskName, String empCode, String comments,
      String dependencies, BuildContext context) async {
    try {
      if (taskName.isEmpty ||
          startDate == null ||
          endDate == null ||
          assignedBy == null ||
          client == null ||
          selectedWorkGroup == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        isLoading = true;
        rebuild();
        List base64Attacments = [];
        for (var e in attachments) {
          final bytes = File(e.path).readAsBytesSync();
          String img64 = base64Encode(bytes);
          base64Attacments.add({"name": e.name, "desc": img64});
        }

        Map<String, dynamic> newWork = {
          "M_FLAG": 3,
          "EMPCODE": empCode,
          "CLIENT": client!.split("-").first,
          "WORKGROUP": selectedWorkGroup!.split("-").first,
          "TASK_NAME": taskName,
          "ASSIGNED_BY": assignedBy!.split("-").first,
          "START_DATE": getDate(startDate!).split("-").reversed.join("-"),
          "END_DATE": getDate(endDate!).split("-").reversed.join("-"),
          "PRIORITY_LOW": selectedPriority == "Low" ? true : null,
          "PRIORITY_MID": selectedPriority == "Mid" ? true : null,
          "PRIORITY_HIGH": selectedPriority == "High" ? true : null,
          "ATTACHMENT_FILE": base64Attacments,
          "WORK_DESCRIPTION": comments,
          "DEPENDENCIES": dependencies,
        };

        FormData formData = FormData.fromMap({"data": jsonEncode(newWork)});

        var res = await ApiServices.createNewWork(formData);
        if (res.data["result"].runtimeType == bool) {
          if (res.data["result"]) {
            mySnackBar("Created Successfully", context);
          } else {
            mySnackBar("Failed To create", context);
          }
        }
        isLoading = false;
        rebuild();
        return true;
      }
    } catch (e) {
      isLoading = false;
      rebuild();
      mySnackBar("Somthing Went Wrong", context);
      return false;
    }
  }

  Future<bool> update(
      String taskName,
      String comments,
      String dependencies,
      BuildContext context,
      String reason,
      String empCode,
      String workId) async {
    try {
      if (taskName.isEmpty ||
          startDate == null ||
          endDate == null ||
          assignedBy == null ||
          client == null ||
          selectedWorkGroup == null ||
          reason.isEmpty) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        isLoading = true;
        rebuild();
        List base64Attacments = [];
        for (var e in attachments) {
          late String img64;

          final bytes = File(e.path).readAsBytesSync();
          img64 = base64Encode(bytes);

          base64Attacments.add({"name": e.name, "desc": img64});
        }

        Map<String, dynamic> newWork = {
          "M_FLAG": 6,
          "EMP_code": empCode,
          "WORKID": workId,
          "WORKGROUP": selectedWorkGroup!.split("-").first,
          "ASSIGNED_BY": assignedBy!.split("-").first,
          "CLIENT": client!.split("-").first,
          "TASK_NAME": taskName,
          "START_DATE": getDate(startDate!).split("-").reversed.join("-"),
          "END_DATE": getDate(endDate!).split("-").reversed.join("-"),
          "DEPENDENCIES": dependencies,
          "PRIORITY_LOW": selectedPriority == "Low" ? true : null,
          "PRIORITY_MID": selectedPriority == "Mid" ? true : null,
          "PRIORITY_HIGH": selectedPriority == "High" ? true : null,
          "WORK_DESCRIPTION": comments,
          "ATTACHMENT_FILE": base64Attacments,
          "WORK_PROGRESS": progressToUpdate,
          "EDITED_REASON": reason
        };

        FormData formData = FormData.fromMap({"data": jsonEncode(newWork)});

        var res = await ApiServices.updateWork(formData);
        if (res.data["result"].runtimeType == bool) {
          if (res.data["result"]) {
            mySnackBar("Updated Successfully", context);
          } else {
            mySnackBar("Failed To Update", context);
          }
        }
        isLoading = false;
        rebuild();

        return true;
      }
    } catch (e) {
      isLoading = false;
      rebuild();
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
