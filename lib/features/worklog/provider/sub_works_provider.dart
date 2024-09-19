import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/provider/worklog_provider.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubWorkProvider extends ChangeNotifier {
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
    BuildContext context,
    String subWorkId,
    String worksDocId,
  ) async {
    try {
      final fir = FirebaseFirestore.instance.collection(subWorkId);
      if (workTitle == null ||
          workDescription.isEmpty ||
          startTime == null ||
          endTime == null ||
          newProgress == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        String subDocId = DateTime.now().toString();

        Map<String, dynamic> subWork = {
          "date": getDate(DateTime.now()),
          "startTime":
              "${startTime!.hour.toString()}:${startTime!.minute.toString()}",
          "endTime":
              "${endTime!.hour.toString()}:${endTime!.minute.toString()}",
          "totalTime": totalTime,
          "taskName": workTitle,
          "taskDecription": workDescription,
          "status": status,
          "attachments": subWorkSttachments.map((e) => e.toJson()).toList(),
          "notes": notes,
          "blockersAndChallanges": blockersAndChallengers,
          "submittedBy": "Faris kk",
          "Id": subDocId,
        };
        await fir.doc(subDocId).set(subWork);
        await FirebaseFirestore.instance
            .collection("works")
            .doc(worksDocId)
            .update({"progress": newProgress!.toInt()});
        Provider.of<WorklogProvider>(context, listen: false).rebuild();
        return true;
      }
    } catch (e) {
      mySnackBar("Somthing Went Wrong", context);
      return false;
    }
  }

  Future<bool> updateWorklog(
    SubWorks subWorkToEdit,
    String? workTitle,
    String workDescription,
    String notes,
    String blockersAndChallengers,
    BuildContext context,
    String subWorkId,
  ) async {
    try {
      final fir = FirebaseFirestore.instance.collection(subWorkId);

      if (workDescription.isEmpty ||
          startTime == null ||
          endTime == null ||
          workTitle == null) {
        mySnackBar("Please Fill all Fields", context);
        return false;
      } else {
        subWorkToEdit.date = getDate(DateTime.now());
        subWorkToEdit.startTime =
            "${startTime!.hour.toString()}:${startTime!.minute.toString()}";
        subWorkToEdit.endTime =
            "${endTime!.hour.toString()}:${endTime!.minute.toString()}";
        subWorkToEdit.totalTime = totalTime!;
        subWorkToEdit.taskName = workTitle;
        subWorkToEdit.taskDecription = workDescription;
        subWorkToEdit.status = status;
        subWorkToEdit.notes = notes;
        subWorkToEdit.blockersAndChallanges = blockersAndChallengers;
        subWorkToEdit.attachments = subWorkSttachments;

        await fir.doc(subWorkToEdit.id).update(subWorkToEdit.toJson());

        notifyListeners();
        if (context.mounted) {
          Provider.of<WorklogProvider>(context, listen: false).rebuild();
          Provider.of<MyWorksProvider>(context, listen: false).rebuild();
        }
        return true;
      }
    } catch (e) {
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
