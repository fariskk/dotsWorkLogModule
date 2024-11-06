import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/provider/worklog_provider.dart';
import 'package:dots_ticcket_module/models/models.dart';
import 'package:dots_ticcket_module/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubWorkProvider extends ChangeNotifier {
  bool isLoading = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double? newProgress;
  double? totalTime;
  int expandedTileIndex = -1;
  String? workTitle;
  List<Attachments> subWorkSttachments = [];
  String status = "In Progress";
  void rebuild() {
    notifyListeners();
  }

  Future<bool> submitWorklog(
    String? workTitle,
    String workDescription,
    String notes,
    String blockersAndChallengers,
    String empCode,
    String workId,
    BuildContext context,
  ) async {
    try {
      if (workTitle == null ||
          workDescription.isEmpty ||
          startTime == null ||
          endTime == null ||
          newProgress == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        isLoading = true;
        rebuild();
        List base64Attacments = [];
        for (var e in subWorkSttachments) {
          final bytes = File(e.path).readAsBytesSync();
          String img64 = base64Encode(bytes);
          base64Attacments.add({"name": e.name, "desc": img64});
        }
        Map<String, dynamic> subWork = {
          "EMP_code": empCode,
          "WORKID": workId,
          "M_FLAG": 10,
          "DATE":
              dateTimetoDDMMYYY(DateTime.now()).split("-").reversed.join("-"),
          "WORK_NOTS": notes,
          "WORK_TITLE": workTitle,
          "WORK_DESCRIPTION": workDescription,
          "START_TIME": "${startTime!.hour}:${startTime!.minute}:00",
          "END_TIME": "${endTime!.hour}:${endTime!.minute}:00",
          "TOTAL_TIME": totalTime.toString().replaceAll(".", ":"),
          "WORK_PROGRESS": newProgress,
          "WORK_COMPLETED_FLAG": status == "Completed" ? true : null,
          "WORK_IN_PROGRESS_FLAG": status == "In Progress" ? true : null,
          "WORK_CHALLENGES": blockersAndChallengers,
          "ATTACHMENT_FILE": base64Attacments
        };
        FormData formData = FormData.fromMap({"data": jsonEncode(subWork)});
        var res = await ApiServices.addSubWork(formData);
        if (res.data["result"].runtimeType == bool) {
          if (res.data["result"]) {
            mySnackBar("Created Successfully", context);
          } else {
            mySnackBar("Failed To Create", context);
          }
        }
        Provider.of<WorklogProvider>(context, listen: false).rebuild();
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

  Future<bool> updateWorklog(
    String empCode,
    String workId,
    int subWorkId,
    String? workTitle,
    String workDescription,
    String notes,
    String blockersAndChallengers,
    BuildContext context,
  ) async {
    try {
      if (workDescription.isEmpty ||
          startTime == null ||
          endTime == null ||
          workTitle == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        isLoading = true;
        rebuild();
        List base64Attacments = [];

        for (var e in subWorkSttachments) {
          late String img64;

          final bytes = File(e.path).readAsBytesSync();
          img64 = base64Encode(bytes);

          base64Attacments.add({"name": e.name, "desc": img64});
        }

        Map<String, dynamic> subWork = {
          "EMP_code": empCode,
          "WORKID": workId,
          "WORK_SUB_ID": subWorkId,
          "M_FLAG": 13,
          "DATE":
              dateTimetoDDMMYYY(DateTime.now()).split("-").reversed.join("-"),
          "WORK_NOTS": notes,
          "WORK_TITLE": workTitle,
          "WORK_DESCRIPTION": workDescription,
          "START_TIME": "${startTime!.hour}:${startTime!.minute}:00",
          "END_TIME": "${endTime!.hour}:${endTime!.minute}:00",
          "TOTAL_TIME": totalTime.toString().replaceAll(".", ":"),
          "WORK_PROGRESS": newProgress,
          "WORK_COMPLETED_FLAG": status == "Completed" ? true : null,
          "WORK_IN_PROGRESS_FLAG": status == "In Progress" ? true : null,
          "WORK_CHALLENGES": blockersAndChallengers,
          "ATTACHMENT_FILE": []
        };
        FormData formData = FormData.fromMap({"data": jsonEncode(subWork)});
        var res = await ApiServices.editSubWork(formData);
        if (res.data["result"].runtimeType == bool) {
          if (res.data["result"]) {
            mySnackBar("Updated Successfully", context);
          } else {
            mySnackBar("Failed To Update", context);
          }
        }
        isLoading = false;
        rebuild();
        if (context.mounted) {
          Provider.of<WorklogProvider>(context, listen: false).rebuild();
          Provider.of<MyWorksProvider>(context, listen: false).rebuild();
        }
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
    startTime = null;
    endTime = null;
    newProgress = null;
    totalTime = null;
    status = "In Progress";
    subWorkSttachments.clear();
    workTitle = null;
    expandedTileIndex = -1;
  }
}
