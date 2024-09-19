import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/screens/add_work_screen.dart';
import 'package:dots_ticcket_module/features/myWorks/widgets/my_works_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
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
  final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();
  @override
  void initState() {
    Provider.of<MyWorksProvider>(context, listen: false).clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWorksProvider>(builder: (context, provider, child) {
      return Builder(builder: (context) {
        AppLocalizations language = AppLocalizations.of(context)!;
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("works").snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data.docs;
              dotsData.works.clear();
              for (var element in data) {
                dotsData.works.add(Works.fromJson(element.data()));
              }

              getChartData();
              List<Works> worksAfterFilterd = dotsData.works;
              worksAfterFilterd =
                  worksAfterFilterd.reversed.map((e) => e).toList();

              if (provider.dateRangeToSort.isNotEmpty) {
                worksAfterFilterd = worksAfterFilterd.where((element) {
                  List dateParts = element.startDate.split("/");
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
              if (provider.selectedTypeForSort != "All") {
                worksAfterFilterd = worksAfterFilterd
                    .where((element) =>
                        element.type == provider.selectedTypeForSort)
                    .toList();
              }
              if (provider.selectedPriorityForSort != "All") {
                worksAfterFilterd = worksAfterFilterd
                    .where((element) =>
                        element.priority ==
                        "${provider.selectedPriorityForSort} Priority")
                    .toList();
              }
              if (provider.selectedStatusForSort != "All") {
                worksAfterFilterd = worksAfterFilterd
                    .where((element) =>
                        element.status == provider.selectedStatusForSort)
                    .toList();
              }
              if (provider.isSearchEnabled) {
                worksAfterFilterd = worksAfterFilterd
                    .where((element) =>
                        element.id.contains(provider.searchKeyword))
                    .toList();
              }
              dotsData.works = worksAfterFilterd;
              // dataGrid = DataGrid(
              //   sfKey: GlobalKey<SfDataGridState>(),
              //   works: dotsData.works,
              // );
              return Scaffold(
                backgroundColor: kMainColor,
                appBar: AppBar(
                  backgroundColor: kMainColor,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {},
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
                                  mySortDropDown(
                                      ["All", "individual", "support"],
                                      (String? value) {
                                    provider.selectedTypeForSort = value!;
                                    provider.rebuild();
                                  }, "Type", provider.selectedTypeForSort),
                                  mySortDropDown(["All", "Low", "Mid", "High"],
                                      (String? value) {
                                    provider.selectedPriorityForSort = value!;
                                    provider.rebuild();
                                  }, "Priority",
                                      provider.selectedPriorityForSort),
                                  mySortDropDown([
                                    "All",
                                    "In Progress",
                                    "Completed",
                                    "On Hold"
                                  ], (String? value) {
                                    provider.selectedStatusForSort = value!;
                                    provider.rebuild();
                                  }, "Status", provider.selectedStatusForSort),
                                ],
                              ))
                          : const SizedBox(),
                      Expanded(
                        child: worksAfterFilterd.isEmpty
                            ? Center(
                                child: Image.asset(
                                  "assets/icons/folder.png",
                                  height: SizeConfigure.widthMultiplier! * 20,
                                  width: SizeConfigure.widthMultiplier! * 30,
                                ),
                              )
                            : ListView.builder(
                                itemCount: worksAfterFilterd.length,
                                itemBuilder: (context, index) {
                                  Works workDetails = dotsData.works[index];

                                  //my works tile
                                  return myWorksTile(context, index,
                                      workDetails, provider, language);
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
                                  builder: (context) => AddWorkScreen()));
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
                          if (dotsData.works.isEmpty) {
                            mySnackBar("No Works Fount", context);
                            return;
                          }
                          if (!await ExcelGenerator.generateExcel(provider) &&
                              context.mounted) {
                            mySnackBar("No Supported App Found", context);
                          }
                          // dataGrid.generateExcel(context);
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
                          if (dotsData.works.isEmpty) {
                            mySnackBar("No Works Fount", context);
                            return;
                          }
                          if (!await PdfGenerator.generatePdf(provider) &&
                              context.mounted) {
                            mySnackBar("No Supported App Found", context);
                          }

                          //dataGrid.generatePdf(context);
                        },
                      ),
                    ],
                    colorStartAnimation: kMainColor,
                    colorEndAnimation: const Color.fromARGB(255, 124, 158, 197),
                    animatedIconData: AnimatedIcons.menu_close),
              );
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      });
    });
  }

  getChartData() {
    chartValues.clear();

    chartValues.add(dotsData.works
        .where((element) => element.status == "Completed")
        .toList()
        .length
        .toDouble());
    chartValues.add(dotsData.works
        .where((element) => element.status == "In Progress")
        .toList()
        .length
        .toDouble());
    chartValues.add(dotsData.works
        .where((element) => element.status == "On Hold")
        .toList()
        .length
        .toDouble());
    chartValues.add(dotsData.works
        .where((element) => getDateDiffrence(element.endDate) < 1)
        .toList()
        .length
        .toDouble());
  }
}
