import 'dart:io';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';

import 'package:excel/excel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExcelGenerator {
  static Future<bool> generateExcel(MyWorksProvider provider) async {
    int filterDetailsIndex = 2;
    var excel = Excel.createExcel();

    Sheet sheet1 = excel["Faris kk"];
    excel.delete("Sheet1");

    sheet1.setDefaultColumnWidth(15);
    //heading style

    CellStyle hedingStyle = CellStyle(
      fontFamily: GoogleFonts.manrope().fontFamily,
      bold: true,
      backgroundColorHex: ExcelColor.cyan300,
      fontSize: 10,
      bottomBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      leftBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      topBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
    );
//Filter details
    var headingCell1 = sheet1.cell(CellIndex.indexByString('E1'));
    headingCell1.value = TextCellValue(
        "Date: ${toDDMMMYYY(dotsData.works.first.startDate)} To ${toDDMMMYYY(dotsData.works.last.startDate)}");
    if (provider.selectedTypeForSort != "All") {
      var headingCell2 =
          sheet1.cell(CellIndex.indexByString('A$filterDetailsIndex'));

      headingCell2.value =
          TextCellValue("Type : ${provider.selectedTypeForSort}");
      filterDetailsIndex++;
    }

    if (provider.selectedPriorityForSort != "All") {
      var headingCell3 =
          sheet1.cell(CellIndex.indexByString('A$filterDetailsIndex'));

      headingCell3.value =
          TextCellValue("Priority : ${provider.selectedPriority} Priority");
      filterDetailsIndex++;
    }

    if (provider.selectedStatusForSort != "All") {
      var headingCell4 =
          sheet1.cell(CellIndex.indexByString('A$filterDetailsIndex'));
      headingCell4.value =
          TextCellValue("Status : ${provider.selectedStatusForSort}");
    }

    //heading

    var taskIdHeadingCell = sheet1.cell(CellIndex.indexByString('A5'));
    var clientNameHeadingCell = sheet1.cell(CellIndex.indexByString('B5'));
    var taskNameHeadingCell = sheet1.cell(CellIndex.indexByString('C5'));
    var assignedByHeadingCell = sheet1.cell(CellIndex.indexByString('D5'));
    var startDateHeadingCell = sheet1.cell(CellIndex.indexByString('E5'));
    var dueDateHeadingCell = sheet1.cell(CellIndex.indexByString('F5'));
    var finalDeliveryDateHeadingCell =
        sheet1.cell(CellIndex.indexByString('G5'));
    var priorityHeadingCell = sheet1.cell(CellIndex.indexByString('H5'));
    var statusHeadingCell = sheet1.cell(CellIndex.indexByString('I5'));
    var commentsHeadingCell = sheet1.cell(CellIndex.indexByString('j5'));
    var progressHeadingCell = sheet1.cell(CellIndex.indexByString('K5'));
    var dependenciesHeadingCell = sheet1.cell(CellIndex.indexByString('L5'));

    taskIdHeadingCell.value = TextCellValue("Task ID");
    taskIdHeadingCell.cellStyle = hedingStyle;

    clientNameHeadingCell.value = TextCellValue("Client Name");
    clientNameHeadingCell.cellStyle = hedingStyle;

    taskNameHeadingCell.value = TextCellValue("Task Name");
    taskNameHeadingCell.cellStyle = hedingStyle;

    assignedByHeadingCell.value = TextCellValue("Assigned  by");
    assignedByHeadingCell.cellStyle = hedingStyle;

    startDateHeadingCell.value = TextCellValue("Start Date");
    startDateHeadingCell.cellStyle = hedingStyle;

    dueDateHeadingCell.value = TextCellValue("Due Date");
    dueDateHeadingCell.cellStyle = hedingStyle;

    finalDeliveryDateHeadingCell.value = TextCellValue("Final Delivery Date");
    finalDeliveryDateHeadingCell.cellStyle = hedingStyle;

    priorityHeadingCell.value = TextCellValue("Priority");
    priorityHeadingCell.cellStyle = hedingStyle;

    statusHeadingCell.value = TextCellValue("Status");
    statusHeadingCell.cellStyle = hedingStyle;

    commentsHeadingCell.value = TextCellValue("Comments");
    commentsHeadingCell.cellStyle = hedingStyle;

    progressHeadingCell.value = TextCellValue("Progress (%)");
    progressHeadingCell.cellStyle = hedingStyle;

    dependenciesHeadingCell.value = TextCellValue("Dependencies");
    dependenciesHeadingCell.cellStyle = hedingStyle;
    //heading end
    //content

    for (int i = 0; i < dotsData.works.length; i++) {
      Works work = dotsData.works[i];

      CellStyle contentStyle = CellStyle(
          verticalAlign: VerticalAlign.Center,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: getCellColor(work.status),
          bottomBorder: Border(
              borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
          rightBorder: Border(
              borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
          leftBorder: Border(
              borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
          topBorder: Border(
              borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin));
      var taskIdCell = sheet1.cell(CellIndex.indexByString('A${i + 6}'));
      var clientNameCell = sheet1.cell(CellIndex.indexByString('B${i + 6}'));
      var taskNameCell = sheet1.cell(CellIndex.indexByString('C${i + 6}'));
      var assignedByCell = sheet1.cell(CellIndex.indexByString('D${i + 6}'));
      var startDateCell = sheet1.cell(CellIndex.indexByString('E${i + 6}'));
      var dueDateCell = sheet1.cell(CellIndex.indexByString('F${i + 6}'));
      var finalDeliveryDateCell =
          sheet1.cell(CellIndex.indexByString('G${i + 6}'));
      var priorityCell = sheet1.cell(CellIndex.indexByString('H${i + 6}'));
      var statusCell = sheet1.cell(CellIndex.indexByString('I${i + 6}'));
      var commentsCell = sheet1.cell(CellIndex.indexByString('j${i + 6}'));
      var progressCell = sheet1.cell(CellIndex.indexByString('K${i + 6}'));
      var dependenciesCell = sheet1.cell(CellIndex.indexByString('L${i + 6}'));
      taskIdCell.value = TextCellValue(work.id);
      clientNameCell.value = TextCellValue(work.client);
      taskNameCell.value = TextCellValue(work.taskName);
      assignedByCell.value = TextCellValue(work.assignedBy);
      startDateCell.value = TextCellValue(toDDMMMYYY(work.startDate));
      dueDateCell.value = TextCellValue(toDDMMMYYY(work.endDate));
      finalDeliveryDateCell.value = TextCellValue(toDDMMMYYY(work.endDate));
      priorityCell.value = TextCellValue(work.priority);
      statusCell.value = TextCellValue(work.status);
      commentsCell.value = TextCellValue(work.comments);
      progressCell.value = IntCellValue(work.progress);
      dependenciesCell.value = TextCellValue(work.dependencies);
      taskIdCell.cellStyle = contentStyle.copyWith(
          boldVal: true, fontColorHexVal: ExcelColor.redAccent);
      clientNameCell.cellStyle = contentStyle;
      taskNameCell.cellStyle = contentStyle;
      assignedByCell.cellStyle = contentStyle;
      startDateCell.cellStyle = contentStyle;
      dueDateCell.cellStyle = contentStyle;
      finalDeliveryDateCell.cellStyle = contentStyle;
      priorityCell.cellStyle = contentStyle;
      statusCell.cellStyle = contentStyle;
      commentsCell.cellStyle = contentStyle;
      progressCell.cellStyle = contentStyle;
      dependenciesCell.cellStyle =
          contentStyle.copyWith(textWrappingVal: TextWrapping.WrapText);
    }
    var fileBytes = excel.save();
    var directory = await getApplicationCacheDirectory();

    File file = File(
        "${directory.path}/Work_log-FarisKK-${getDate(DateTime.now()).replaceAll("/", "-")}.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    return await OpenFile.open(file.path).then((result) {
      if (result.message == "done") {
        return true;
      }

      return false;
    });
  }
}

ExcelColor getCellColor(String status) {
  switch (status) {
    case "Completed":
      return ExcelColor.green;
    case "On Hold":
      return ExcelColor.orange;
    case "In Progress":
      return ExcelColor.yellow;
    default:
      return ExcelColor.white;
  }
}
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dots_ticcket_module/common/common.dart';
// import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
// import 'package:dots_ticcket_module/utils/dummy_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_datagrid_export/export.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// class DataGrid extends StatefulWidget {
//   DataGrid({required this.sfKey, required this.works});
//   GlobalKey<SfDataGridState> sfKey;
//   List<Works> works;
//   generatePdf(BuildContext context) async {
//     int i = -1;
//     final provider = Provider.of<MyWorksProvider>(context, listen: false);
//     ByteData byteData = await rootBundle.load('assets/dots_logo.jpg');
//     Uint8List imageBytes = byteData.buffer.asUint8List();
//     PdfDocument document = sfKey.currentState!.exportToPdfDocument(
//       exportStackedHeaders: false,
//       canRepeatHeaders: false,
//       headerFooterExport:
//           (DataGridPdfHeaderFooterExportDetails headerFooterExport) {
//         final double width = headerFooterExport.pdfPage.getClientSize().width;
//         final double height = headerFooterExport.pdfPage.getClientSize().height;
//         final PdfPageTemplateElement header =
//             PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 90));

//         header.graphics.drawString(
//           'Work Report',
//           PdfStandardFont(PdfFontFamily.helvetica, 13,
//               style: PdfFontStyle.bold),
//           bounds: Rect.fromLTWH(240, 25, 200, 30),
//         );

//         header.graphics
//             .drawImage(PdfBitmap(imageBytes), Rect.fromLTWH(0, 0, 50, 30));

//         header.graphics.drawString(
//           '${toDDMMMYYY(dotsData.works.first.startDate)} To ${toDDMMMYYY(dotsData.works.last.startDate)}',
//           PdfStandardFont(
//             PdfFontFamily.helvetica,
//             8,
//           ),
//           bounds: const Rect.fromLTWH(220, 45, 200, 30),
//         );

//         if (provider.selectedTypeForSort != "All") {
//           header.graphics.drawString(
//             'Type : ${provider.selectedTypeForSort}',
//             PdfStandardFont(
//               PdfFontFamily.helvetica,
//               8,
//             ),
//             bounds: const Rect.fromLTWH(0, 55, 200, 30),
//           );
//         }

//         if (provider.selectedStatusForSort != "All") {
//           header.graphics.drawString(
//             'Status : ${provider.selectedStatusForSort}',
//             PdfStandardFont(
//               PdfFontFamily.helvetica,
//               8,
//             ),
//             bounds: const Rect.fromLTWH(0, 65, 200, 30),
//           );
//         }
//         if (provider.selectedPriorityForSort != "All") {
//           header.graphics.drawString(
//             'Priority : ${provider.selectedPriorityForSort}',
//             PdfStandardFont(
//               PdfFontFamily.helvetica,
//               8,
//             ),
//             bounds: const Rect.fromLTWH(0, 75, 200, 60),
//           );
//         }
//         headerFooterExport.pdfDocumentTemplate.top = header;
//         //headerFooterExport.pdfDocumentTemplate.bottom = header;
//       },
//       fitAllColumnsInOnePage: true,
//       cellExport: (details) {
//         if (details.cellType == DataGridExportCellType.columnHeader) {
//           details.pdfCell.style.backgroundBrush = PdfBrushes.lightGray;
//           details.pdfCell.stringFormat.alignment = PdfTextAlignment.center;

//           details.pdfCell.stringFormat.lineAlignment =
//               PdfVerticalAlignment.middle;
//           return;
//         }
//         if (dotsData.works.length - 1 > i && details.columnName == "Task ID") {
//           i++;
//         }
//         details.pdfCell.stringFormat.alignment = PdfTextAlignment.center;
//         details.pdfCell.stringFormat.wordWrap = PdfWordWrapType.character;

//         details.pdfCell.stringFormat.lineAlignment =
//             PdfVerticalAlignment.middle;

//         switch (dotsData.works[i].status) {
//           case "Completed":
//             details.pdfCell.style.backgroundBrush = PdfBrushes.limeGreen;

//             break;
//           case "On Hold":
//             details.pdfCell.style.backgroundBrush = PdfBrushes.orange;
//             break;
//           case "In Progress":
//             details.pdfCell.style.backgroundBrush = PdfBrushes.yellow;
//             break;
//           default:
//             details.pdfCell.style.backgroundBrush = PdfBrushes.black;
//             break;
//         }
//       },
//     );

//     final List<int> bytes = document.saveSync();
//     Directory dir = await getApplicationCacheDirectory();
//     File file = File("${dir.path}/${toDDMMMYYY(getDate(DateTime.now()))}.pdf");
//     await file.writeAsBytes(bytes);
//     OpenFile.open(file.path);
//     document.dispose();
//   }

//   generateExcel(BuildContext context) async {
//     int i = -1;
//     final Workbook workbook = sfKey.currentState!.exportToExcelWorkbook(
//         cellExport: (DataGridCellExcelExportDetails details) {
//       if (details.cellType == DataGridExportCellType.columnHeader) {
//         details.excelRange.cellStyle.backColor = "#c1c3c9";
//         details.excelRange.cellStyle.bold = true;
//         details.excelRange.cellStyle.borders.all.lineStyle = LineStyle.thin;
//         return;
//       }
//       if (dotsData.works.length - 1 > i && details.columnName == "Task ID") {
//         i++;
//         print(i);
//       }
//       details.excelRange.cellStyle.hAlign = HAlignType.center;
//       details.excelRange.cellStyle.vAlign = VAlignType.center;
//       details.excelRange.cellStyle.borders.all.lineStyle = LineStyle.thin;
//       switch (dotsData.works[i].status) {
//         case "Completed":
//           details.excelRange.cellStyle.backColor = "#42f563";

//           break;
//         case "On Hold":
//           details.excelRange.cellStyle.backColor = "#f7af1e";

//           break;
//         case "In Progress":
//           details.excelRange.cellStyle.backColor = "#ddf50a";

//           break;
//         default:
//           details.excelRange.cellStyle.backColor = "#1d3cc4";
//           break;
//       }
//     });
//     workbook.worksheets.innerList.first.name = "Faris kk";
//     final provider = Provider.of<MyWorksProvider>(context, listen: false);
//     workbook.worksheets.innerList.first.insertRow(1, 1);
//     workbook.worksheets.innerList.first.insertRow(1, 1);
//     workbook.worksheets.innerList.first.insertRow(1, 1);
//     Range range1 = workbook.worksheets[0].getRangeByIndex(2, 5);
//     range1.cells[0].value = "Type : ${provider.selectedTypeForSort}";
//     Range range2 = workbook.worksheets[0].getRangeByIndex(2, 6);
//     range2.cells[0].value = "Status : ${provider.selectedStatusForSort}";
//     Range range3 = workbook.worksheets[0].getRangeByIndex(2, 7);
//     range3.cells[0].value = "Priority : ${provider.selectedPriorityForSort}";

//     final List<int> bytes = workbook.saveAsStream();
//     Directory dir = await getApplicationCacheDirectory();
//     File file = File("${dir.path}/${toDDMMMYYY(getDate(DateTime.now()))}.xlsx");
//     await file.writeAsBytes(bytes);
//     OpenFile.open(file.path);
//     workbook.dispose();
//   }

//   @override
//   State<DataGrid> createState() => _DataGridState();
// }

// class _DataGridState extends State<DataGrid> {
//   List<DataRow> _works = <DataRow>[];
//   late WorksDataSource _worksDataSource;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyWorksProvider>(builder: (context, provider, child) {
//       _works = _getWorksData();
//       _worksDataSource = WorksDataSource(workData: _works);
//       return SizedBox(
//         height: 0,
//         width: 0,
//         child: SfDataGrid(
//           key: widget.sfKey,
//           source: _worksDataSource,
//           columns: <GridColumn>[
//             GridColumn(
//                 columnName: 'Task ID',
//                 label: Container(
//                     padding: const EdgeInsets.all(16.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Task ID',
//                     ))),
//             GridColumn(
//                 columnName: 'Client Name',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Client Name'))),
//             GridColumn(
//                 columnName: 'Task Name',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Task Name',
//                       overflow: TextOverflow.ellipsis,
//                     ))),
//             GridColumn(
//                 columnName: 'Assigned  by',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Assigned  by'))),
//             GridColumn(
//                 columnName: 'Start Date',
//                 label: Container(
//                     padding: const EdgeInsets.all(16.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Start Date',
//                     ))),
//             GridColumn(
//                 columnName: 'Due Date',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Due Date'))),
//             GridColumn(
//                 columnName: 'Final Delivery Date',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Final Delivery Date',
//                       overflow: TextOverflow.ellipsis,
//                     ))),
//             GridColumn(
//                 columnName: 'Priority',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Priority'))),
//             GridColumn(
//                 columnName: 'Status',
//                 label: Container(
//                     padding: const EdgeInsets.all(16.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Status',
//                     ))),
//             GridColumn(
//                 columnName: 'Comments',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Comments'))),
//             GridColumn(
//                 columnName: 'Progress (%)',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Progress (%)',
//                       overflow: TextOverflow.ellipsis,
//                     ))),
//             GridColumn(
//                 columnName: 'Dependencies',
//                 label: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     alignment: Alignment.center,
//                     child: const Text('Dependencies'))),
//           ],
//         ),
//       );
//     });
//   }

//   List<DataRow> _getWorksData() {
//     print(dotsData.works);
//     return dotsData.works.map((e) {
//       return DataRow(
//           id: e.id,
//           progress: e.progress,
//           client: e.client,
//           taskName: e.taskName,
//           assignedBy: e.assignedBy,
//           comments: e.comments,
//           dependencies: e.dependencies,
//           endDate: e.endDate,
//           finalDeliveryDate: e.endDate,
//           priority: e.priority,
//           startDate: e.startDate,
//           status: e.status);
//     }).toList();
//   }
// }

// class DataRow {
//   DataRow({
//     required this.id,
//     required this.progress,
//     required this.client,
//     required this.taskName,
//     required this.assignedBy,
//     required this.comments,
//     required this.dependencies,
//     required this.endDate,
//     required this.finalDeliveryDate,
//     required this.priority,
//     required this.startDate,
//     required this.status,
//   });

//   late String id;

//   late int progress;
//   late String client;

//   late String taskName;
//   late String assignedBy;
//   late String finalDeliveryDate;
//   late String startDate;
//   late String endDate;
//   late String priority;
//   late String status;

//   late String comments;

//   late String dependencies;
// }

// class WorksDataSource extends DataGridSource {
//   WorksDataSource({required List<DataRow> workData}) {
//     _employeeData = workData
//         .map<DataGridRow>((DataRow e) => DataGridRow(cells: <DataGridCell>[
//               DataGridCell<String>(columnName: 'Task ID', value: e.id),
//               DataGridCell<String>(columnName: 'Client Name', value: e.client),
//               DataGridCell<String>(columnName: 'Task Name', value: e.taskName),
//               DataGridCell<String>(
//                   columnName: 'Assigned  by', value: e.assignedBy),
//               DataGridCell<String>(
//                   columnName: 'Start Date', value: e.startDate),
//               DataGridCell<String>(columnName: 'Due Date', value: e.endDate),
//               DataGridCell<String>(
//                   columnName: 'Final Delivery Date', value: e.endDate),
//               DataGridCell<String>(columnName: 'Priority', value: e.priority),
//               DataGridCell<String>(columnName: 'Status', value: e.status),
//               DataGridCell<String>(columnName: 'Comments', value: e.comments),
//               DataGridCell<int>(columnName: 'Progress (%)', value: e.progress),
//               DataGridCell<String>(
//                   columnName: 'Dependencies', value: e.dependencies),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _employeeData = <DataGridRow>[];

//   @override
//   List<DataGridRow> get rows => _employeeData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         key: UniqueKey(),
//         color: Colors.cyanAccent,
//         cells: row.getCells().map<Widget>((DataGridCell cell) {
//           return Container(
//             decoration: BoxDecoration(color: Colors.red),
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               cell.value.toString(),
//               style: TextStyle(color: Colors.green),
//             ),
//           );
//         }).toList());
//   }
// }
