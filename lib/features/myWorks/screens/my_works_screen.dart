import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/screens/add_work_screen.dart';
import 'package:dots_ticcket_module/features/myWorks/widgets/my_works_widgets.dart';
import 'package:dots_ticcket_module/services/api_services.dart';
import 'package:dots_ticcket_module/utils/excel_generator.dart';
import 'package:dots_ticcket_module/utils/pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyWorksScreen extends StatefulWidget {
  const MyWorksScreen({super.key});

  @override
  State<MyWorksScreen> createState() => _MyWorksScreenState();
}

class _MyWorksScreenState extends State<MyWorksScreen> {
  List chartValues = [];
  String empCode = "DOT002";
  String empName = "Muhammed faris kk";
  String empemail = "Muhammedfariskk@gmail.com";
  String empDesignation = "Developer";

  final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();
  @override
  void initState() {
    Provider.of<MyWorksProvider>(context, listen: false).clear();
    ApiServices.getDropdownValues(empCode, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWorksProvider>(builder: (context, provider, child) {
      return Builder(builder: (context) {
        AppLocalizations language = AppLocalizations.of(context)!;
        return FutureBuilder(
          future: ApiServices.getAllWorks(empCode),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && !provider.isLoading) {
              var data = snapshot.data.data["result"];
              List works = data[5];

              getChartData(data);

              if (provider.dateRangeToSort.isNotEmpty) {
                works = works.where((element) {
                  List dateParts = element["END_DATE"].split("-");
                  DateTime date = DateTime(int.parse(dateParts[2]),
                      int.parse(dateParts[1]), int.parse(dateParts[0]));

                  if (date.isAfter(provider.dateRangeToSort.first!
                          .subtract(const Duration(days: 1))) &&
                      date.isBefore(provider.dateRangeToSort.last!
                          .add(const Duration(days: 1)))) {
                    return true;
                  }

                  return false;
                }).toList();
              }
              // if (provider.selectedTypeForSort != "All") {
              //   works = works
              //       .where((element) =>
              //           element.type == provider.selectedTypeForSort)
              //       .toList();
              // }
              if (provider.selectedPriorityForSort != "All") {
                works = works
                    .where((element) =>
                        getPriorityInString(
                            element["PRIORITY_LOW"],
                            element["PRIORITY_MID"],
                            element["PRIORITY_HIGH"]) ==
                        provider.selectedPriorityForSort)
                    .toList();
              }
              if (provider.selectedStatusForSort != "All") {
                works = works
                    .where((element) =>
                        element["WORK_STATUS"] ==
                        provider.selectedStatusForSort)
                    .toList();
              }
              if (provider.isSearchEnabled) {
                works = works
                    .where((element) =>
                        element["WORKID"].contains(provider.searchKeyword))
                    .toList();
              }
              return Scaffold(
                backgroundColor: kMainColor,
                appBar: AppBar(
                  backgroundColor: kMainColor,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () async {},
                  ),
                  title: myText(language.myWorks,
                      fontSize: 2.5, color: Colors.white),
                  actions: [
                    myLanguageButton(),
                    mySpacer(width: SizeConfigure.widthMultiplier! * 4.5)
                  ],
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: chartValues[0] +
                                chartValues[1] +
                                chartValues[2] +
                                chartValues[3] !=
                            0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 25),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Column(
                            children: [
                              mySpacer(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  myText(language.workOverview,
                                      fontSize: 2, fontWeight: FontWeight.w600),
                                ],
                              ),

                              //pie chart section
                              myChartWidget(
                                  context, provider, chartValues, language),
                            ],
                          ),
                        ),
                      ),
                      mySpacer(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            myFilterAndSearchSection(
                                provider, language, context),
                            //search field
                            mySearchField(provider, context, language)
                          ],
                        ),
                      ),
                      provider.isFilterOn
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              height: 60,
                              padding: const EdgeInsets.only(
                                  top: 15, left: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 69, 92, 114)
                                      .withOpacity(.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  mySortByDateRangeWidget(provider, context),
                                  // mySortDropDown(
                                  //     ["All", "individual", "support"],
                                  //     (String? value) {
                                  //   provider.selectedTypeForSort = value!;
                                  //   provider.rebuild();
                                  // }, "Type", provider.selectedTypeForSort),
                                  mySortDropDown(["All", "Low", "Mid", "High"],
                                      (String? value) {
                                    provider.selectedPriorityForSort = value!;
                                    provider.rebuild();
                                  }, "Priority",
                                      provider.selectedPriorityForSort),
                                  mySortDropDown([
                                    "All",
                                    "PENDING",
                                    "COMPLETED",
                                    "ON_HOLD"
                                  ], (String? value) {
                                    provider.selectedStatusForSort = value!;
                                    provider.rebuild();
                                  }, "Status", provider.selectedStatusForSort),
                                ],
                              ))
                          : const SizedBox(),
                      Expanded(
                        child: works.isEmpty
                            ? Center(
                                child: Image.asset(
                                  "assets/icons/folder.png",
                                  height: SizeConfigure.widthMultiplier! * 20,
                                  width: SizeConfigure.widthMultiplier! * 30,
                                ),
                              )
                            : ListView.builder(
                                itemCount: works.length,
                                itemBuilder: (context, index) {
                                  Map workDetails = works[index];

                                  //my works tile
                                  return myWorksTile(context, index,
                                      workDetails, provider, language, empCode);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: AnimatedFloatingActionButton(
                    key: fabKey,
                    fabButtons: <Widget>[
                      FloatingActionButton(
                        backgroundColor: kMainColor,
                        heroTag: null,
                        onPressed: () {
                          fabKey.currentState?.animate();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddWorkScreen(
                                        empCode: empCode,
                                      )));
                        },
                        child: Image.asset(
                          "assets/icons/add.png",
                          height: 25,
                          color: Colors.white,
                          width: 25,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: kMainColor,
                        heroTag: null,
                        onPressed: () async {
                          fabKey.currentState?.animate();
                          if (works.isEmpty) {
                            mySnackBar("No Works Fount", context);
                            return;
                          }
                          if (!await ExcelGenerator.generateExcel(
                                  provider: provider,
                                  works: works,
                                  empName: empName) &&
                              context.mounted) {
                            mySnackBar("No Supported App Found", context);
                          }
                        },
                        child: Image.asset(
                          "assets/icons/xls.png",
                          height: 25,
                          color: Colors.white,
                          width: 25,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: kMainColor,
                        heroTag: null,
                        child: Image.asset(
                          "assets/icons/download-pdf.png",
                          color: Colors.white,
                          height: 25,
                          width: 25,
                        ),
                        onPressed: () async {
                          fabKey.currentState?.animate();
                          if (works.isEmpty) {
                            mySnackBar("No Works Fount", context);
                            return;
                          }
                          if (!await PdfGenerator.generatePdf(
                                  provider: provider,
                                  works: works,
                                  empName: empName,
                                  email: empemail,
                                  designation: empDesignation) &&
                              context.mounted) {
                            mySnackBar("No Supported App Found", context);
                          }
                        },
                      ),
                    ],
                    colorStartAnimation: kMainColor,
                    colorEndAnimation: const Color.fromARGB(255, 124, 158, 197),
                    animatedIconData: AnimatedIcons.menu_close),
              );
            }
            return const LoadingScreen();
          },
        );
      });
    });
  }

  getChartData(List data) {
    chartValues.clear();

    chartValues.add(data[1][0]["COMPLETED"].toDouble());
    chartValues.add(data[0][0]["PENDING"].toDouble());
    chartValues.add(data[2][0]["ON_HOLD"].toDouble());
    chartValues.add(data[3][0]["OVERDUE"].toDouble());
  }
}
