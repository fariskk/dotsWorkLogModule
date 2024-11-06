import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApiServices {
  static String baseUrl = "http://gopluspunch.dotshr.com/apigopluspunch/";
// get all works
  static Future getAllWorks(
    String empCode,
  ) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 4})
    });

    return await post("dndApi/get_Work_log_dashbord_mobile", formData);
  }

//create work
  static Future createNewWork(FormData formData) async {
    return await post("dndApi/get_save_WorkLog_data_mobile", formData);
  }

//get work details
  static Future getWorkDetails(String empCode, String workId) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 14, "WORKID": workId})
    });
    return await post("dndApi/get_Work_log_update_data_load_mobile", formData);
  }

// get intial values for edit work
  static Future getInitialValuesForEditWork(
      String empCode, String workId) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 14, "WORKID": workId})
    });
    return await post("dndApi/get_Work_log_update_data_load_mobile", formData);
  }

//delete work
  static Future deleteWork(String empCode, String workId) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 5, "WORKID": workId})
    });
    return await post("dndApi/get_Work_log_data_delete_mobile", formData);
  }

// update work
  static Future updateWork(FormData formData) async {
    return await post("dndApi/get_Work_log_data_edit_mobile", formData);
  }

//get dropdown values
  static Future getDropdownValues(String empCode, BuildContext context) async {
    final provider = Provider.of<CommonProvider>(context, listen: false);
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 1})
    });
    var res = await post("dndApi/get_workLog_details_mobile", formData);
    List data = res.data["result"];

    List<String> workGroup = [];

    data[0].forEach((e) {
      workGroup.add("${e["id"]}-${e["work_group"]}");
    });
    List<String> employees = [];
    data[1].forEach((e) {
      employees.add("${e["slno"]}-${e["employee_name"]}");
    });
    List<String> clients = [];
    data[2].forEach((e) {
      clients.add("${e["id"]}-${e["client_name"]}");
    });
    provider.companyes = workGroup;
    provider.employees = employees;
    provider.clients = clients;
  }

// get all sub works
  static Future getAllSubWorks(String empCode, String workId) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({"EMP_code": empCode, "M_FLAG": 8, "WORKID": workId})
    });
    return await post("dndApi/get_daily_Work_log_report_mobile", formData);
  }

//add sub work
  static Future addSubWork(FormData formData) async {
    return await post(
        "dndApi/get_daily_Work_log__Save_report_mobile", formData);
  }

//edit sub work
  static Future editSubWork(FormData formData) async {
    return await post("dndApi/get_daily_Work_log_edit_mobile", formData);
  }

//delete sub work
  static Future deleteSubWork(
      String empCode, String workId, int subWorkId) async {
    FormData formData = FormData.fromMap({
      "data": jsonEncode({
        "EMP_code": empCode,
        "WORKID": workId,
        "M_FLAG": 11,
        "WORK_SUB_ID": subWorkId,
        "DATE": dateTimetoDDMMYYY(DateTime.now()).split("-").reversed.join("-")
      })
    });
    return await post("dndApi/get_daily_Work_log_Delete_mobile", formData);
  }

//post method
  static post(String url, Object data) async {
    try {
      Dio dio = Dio();
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          logPrint: print,
          retries: 5,
          retryDelays: const [
            Duration(seconds: 1),
            Duration(seconds: 2),
            Duration(seconds: 3),
            Duration(seconds: 4),
          ],
        ),
      );
      var res = await dio.post(baseUrl + url, data: data);
      return res;
    } catch (e) {
      throw "post methode error";
    }
  }
}
