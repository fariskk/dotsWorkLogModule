import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/screens/add_work_screen.dart';
import 'package:dots_ticcket_module/features/worklog/screens/worklog_screen.dart';
import 'package:dots_ticcket_module/features/worklog/widgets/worklog_screen_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

InkWell myWorksTile(BuildContext context, int index, Works workDetails,
    MyWorksProvider provider, AppLocalizations language) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorklogScreen(
                    workDetailsIndex: index,
                  )));
    },
    child: Slidable(
      endActionPane: ActionPane(
        extentRatio: .55,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.grey[100]!,
            foregroundColor: Colors.black,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: myText(language.deleteWor, fontSize: 2.5),
                      content: myText(language.deleteWorkDialog,
                          textOverflow: TextOverflow.visible),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: myText(language.cancel)),
                        TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("works")
                                  .doc(workDetails.id)
                                  .delete();
                              var snapshots = await FirebaseFirestore.instance
                                  .collection(workDetails.subWork)
                                  .get();
                              for (var doc in snapshots.docs) {
                                await doc.reference.delete();
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              provider.rebuild();
                            },
                            child: myText(language.ok))
                      ],
                    );
                  });
            },
          ),
          SlidableAction(
            backgroundColor: Colors.grey[100]!,
            key: UniqueKey(),
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (BuildContext context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddWorkScreen(
                            isToEdit: true,
                            workToEdit: workDetails,
                          )));
            },
          ),
        ],
      ),
      child: SizedBox(
        height: SizeConfigure.widthMultiplier! * 21,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(8),
              height: SizeConfigure.widthMultiplier! * 22,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: SizeConfigure.widthMultiplier! * 10,
                      width: SizeConfigure.widthMultiplier! * 10,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor:
                                const Color.fromARGB(255, 232, 228, 228),
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            color: Colors.green,
                            value: workDetails.progress / 100,
                          ),
                          myText("${workDetails.progress}%", fontSize: 1)
                        ],
                      )),
                  mySpacer(width: SizeConfigure.widthMultiplier! * 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mySpacer(height: SizeConfigure.widthMultiplier! * 1),
                      SizedBox(
                        width: SizeConfigure.widthMultiplier! * 35,
                        child: myText(workDetails.taskName,
                            fontSize: 2,
                            fontWeight: FontWeight.w700,
                            color: kMainColor),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myText(
                                "Due Date : ${toDDMMMYYY(workDetails.endDate)}",
                                fontSize: 1,
                                color: const Color.fromARGB(255, 86, 85, 85)),
                            mySpacer(width: 30),
                            myText(workDetails.status,
                                fontSize: 1.2,
                                fontWeight: FontWeight.w700,
                                color: getTextColor(workDetails.status)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  mySpacer(width: SizeConfigure.widthMultiplier! * 4.5)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                myText("     ${workDetails.id}",
                    maxLength: 30, fontSize: 1.7, fontWeight: FontWeight.bold),
                Visibility(
                  visible: workDetails.createdDate == getDate(DateTime.now()),
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    height: 20,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: myText("New",
                          fontSize: 1.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Row myPriorityWidget(String text, MyWorksProvider provider) {
  return Row(
    children: [
      Checkbox(
          value: provider.selectedPriority == text ? true : false,
          onChanged: (val) {
            provider.selectedPriority = text;
            provider.rebuild();
          }),
      myText(text)
    ],
  );
}

Container mySortByDateRangeWidget(
    MyWorksProvider provider, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10, left: 5),
    height: 70,
    child: provider.dateRangeToSort.isEmpty
        ? InkWell(
            onTap: () async {
              var res = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                  ),
                  dialogSize: Size(SizeConfigure.widthMultiplier! * 90,
                      SizeConfigure.widthMultiplier! * 90));
              if (res != null && res.isNotEmpty) {
                provider.dateRangeToSort = res;

                provider.rebuild();
              }
            },
            child: const Icon(
              Icons.calendar_month,
              size: 20,
            ))
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  myText(getDate(provider.dateRangeToSort.first!), fontSize: 1),
                  myText("TO", fontSize: .7),
                  myText(getDate(provider.dateRangeToSort.last!), fontSize: 1),
                ],
              ),
              mySpacer(width: SizeConfigure.widthMultiplier! * 2),
              InkWell(
                  onTap: () {
                    provider.dateRangeToSort.clear();
                    provider.rebuild();
                  },
                  child: const Icon(
                    Icons.cancel,
                    size: 15,
                  ))
            ],
          ),
  );
}

SizedBox mySortDropDown(
    List items, Function function, String hint, String selectedValue) {
  return SizedBox(
    height: 50,
    child: Stack(
      children: [
        DropdownButton(
            underline: const SizedBox(),
            value: selectedValue,
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: myText(e, fontSize: 1.5, color: Colors.black),
                    ))
                .toList(),
            onChanged: (value) {
              function(value);
            }),
        myText(hint, fontSize: 1)
      ],
    ),
  );
}

Row myDateWidget(
    BuildContext context, MyWorksProvider provider, AppLocalizations language) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          provider.endDate = null;
          var res = await showCalendarDatePicker2Dialog(
              context: context,
              config: CalendarDatePicker2WithActionButtonsConfig(
                  firstDate: DateTime.now()),
              dialogSize: Size(
                  MediaQuery.of(context).size.width -
                      SizeConfigure.widthMultiplier! * 15,
                  MediaQuery.of(context).size.width -
                      SizeConfigure.widthMultiplier! * 15));
          if (res != null) {
            provider.startDate = res[0];
            provider.rebuild();
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: SizeConfigure.widthMultiplier! * 12,
              width: SizeConfigure.widthMultiplier! * 35,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfigure.widthMultiplier! * 10.6,
                  width: SizeConfigure.widthMultiplier! * 42,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myText(
                            provider.startDate != null
                                ? getDate(provider.startDate!)
                                : "DD/MM/YYYY",
                            fontSize: 1.8),
                        mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                        provider.startDate != null
                            ? const Icon(
                                Icons.cancel,
                                size: 18,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            myText("   ${language.startDate}",
                fontSize: 1, fontWeight: FontWeight.w700),
          ],
        ),
      ),
      myText("--", fontSize: 1.8, fontWeight: FontWeight.w500),
      InkWell(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (provider.startDate == null) {
            mySnackBar("Please Select Start Date", context);
          } else {
            var res = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                    firstDate: provider.startDate),
                dialogSize: Size(
                    MediaQuery.of(context).size.width -
                        SizeConfigure.widthMultiplier! * 15,
                    MediaQuery.of(context).size.width -
                        SizeConfigure.widthMultiplier! * 15));
            if (res != null) {
              provider.endDate = res[0];
              provider.rebuild();
            }
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: SizeConfigure.widthMultiplier! * 12,
              width: SizeConfigure.widthMultiplier! * 35,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfigure.widthMultiplier! * 10.6,
                  width: SizeConfigure.widthMultiplier! * 42,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myText(
                            provider.endDate != null
                                ? getDate(provider.endDate!)
                                : "DD/MM/YYYY",
                            fontSize: 1.8),
                        mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                        provider.endDate != null
                            ? const Icon(
                                Icons.cancel,
                                size: 18,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            myText("   ${language.dueDate}",
                fontSize: 1, fontWeight: FontWeight.w700),
          ],
        ),
      ),
    ],
  );
}

SizedBox myClientdropDown(
    BuildContext context, MyWorksProvider provider, AppLocalizations language) {
  return SizedBox(
      width: SizeConfigure.widthMultiplier! * 42,
      height: SizeConfigure.widthMultiplier! * 14,
      child: myTypeHeadDropDown(
          items: Provider.of<CommonProvider>(context, listen: false).clients,
          hintText: language.client,
          labelText: language.client,
          value: provider.client,
          onSelected: (asiignedBy) {
            provider.client = asiignedBy;
            provider.rebuild();
          },
          onCancel: () {
            provider.client = null;

            provider.rebuild();
          }));
}

Container myAssignedByDropDown(
    MyWorksProvider provider, AppLocalizations language, BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(left: 5, right: 5),
    decoration: const BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.all(Radius.circular(25))),
    width: SizeConfigure.widthMultiplier! * 42,
    height: SizeConfigure.widthMultiplier! * 14,
    child: Row(
      children: [
        Image.asset(
          "assets/icons/user.png",
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: myTypeHeadDropDown(
                inputBorder: InputBorder.none,
                items: Provider.of<CommonProvider>(context, listen: false)
                    .employees,
                hintText: language.employee,
                labelText: language.assignedBY,
                value: provider.assignedBy,
                onSelected: (asiignedBy) {
                  provider.assignedBy = asiignedBy;
                  provider.rebuild();
                },
                onCancel: () {
                  provider.assignedBy = null;

                  provider.rebuild();
                }))
      ],
    ),
  );
}

Row updateProgressWidget(
    BuildContext context, MyWorksProvider provider, AppLocalizations language) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      myText(language.progress,
          fontSize: 2,
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(255, 103, 100, 100)),
      SizedBox(
        width: MediaQuery.of(context).size.width -
            SizeConfigure.widthMultiplier! * 36,
        child: FlutterSlider(
          handler: FlutterSliderHandler(
              child: const Icon(
            Icons.percent,
            size: 12,
          )),
          min: 0,
          max: 100,
          trackBar: const FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(color: kMainColor)),
          values: [provider.progressToUpdate],
          onDragCompleted: (a, value, b) {
            provider.progressToUpdate = value;
          },
        ),
      ),
    ],
  );
}

SizedBox addWorkAttachFilesection(
    BuildContext context, MyWorksProvider provider, AppLocalizations language) {
  return SizedBox(
    height: 45,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.attachments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () async {
                var files = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: [
                    'jpg',
                    'xls',
                    'xlsx',
                    'pdf',
                    'xlsm',
                    'csv',
                  ],
                );
                if (files != null) {
                  for (var file in files.files) {
                    if (file.size / 1024 > 10000) {
                      mySnackBar(
                          "${file.name} Size is Grater Than 10 MB", context);
                      continue;
                    }

                    provider.attachments
                        .add(Attachments(name: file.name, path: file.path!));
                  }
                  provider.rebuild();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 237, 237),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 15,
                      color: kMainColor,
                    ),
                    mySpacer(width: 5),
                    Text(
                      provider.attachments.isEmpty
                          ? language.attachFile
                          : language.add,
                    )
                  ],
                ),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.all(5),
            width: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 237, 237, 237),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  size: 15,
                  color: kMainColor,
                ),
                mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                myText(provider.attachments[index - 1].name,
                    maxLength: 18, fontSize: 1.4),
                IconButton(
                    onPressed: () {
                      provider.attachments.removeAt(index - 1);
                      provider.rebuild();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 12,
                    ))
              ],
            ),
          );
        }),
  );
}

Row chartIndIcatorWidget(String text, Color color) {
  return Row(
    children: [
      Container(
        margin: const EdgeInsets.all(8),
        height: SizeConfigure.widthMultiplier! * 3,
        width: SizeConfigure.widthMultiplier! * 3,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
      ),
      myText(text, fontSize: 1.5)
    ],
  );
}

PieChartSectionData chartData(Color color, double value, int index) {
  return PieChartSectionData(
      radius: 25,
      color: color,
      value: value,
      title: "",
      titleStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
}

Visibility mySearchField(
    MyWorksProvider provider, BuildContext context, AppLocalizations language) {
  return Visibility(
      visible: provider.isSearchEnabled,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        width: SizeConfigure.widthMultiplier! * 90,
        height: SizeConfigure.widthMultiplier! * 12,
        decoration: const BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
            onChanged: (value) {
              provider.searchKeyword = value;
              provider.rebuild();
            },
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                hintText: language.workId,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    provider.isSearchEnabled = false;
                    provider.searchKeyword = "";
                    provider.rebuild();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ))),
      ));
}

Row myFilterAndSearchSection(
    MyWorksProvider provider, AppLocalizations language, BuildContext context) {
  return Row(
    children: [
      myText(language.myWorks, fontSize: 2, fontWeight: FontWeight.w700),
      const Expanded(child: SizedBox()),
      IconButton(
          onPressed: () async {
            if (!provider.isFilterOn) {
              provider.isFilterOn = true;
              provider.rebuild();
            } else {
              provider.isFilterOn = false;
              provider.dateRangeToSort.clear();
              provider.selectedPriorityForSort = "All";
              provider.selectedStatusForSort = "All";
              provider.selectedTypeForSort = "All";
              provider.rebuild();
            }
          },
          icon: provider.isFilterOn
              ? const Icon(Icons.cancel)
              : const Icon(Icons.filter_alt)),
      InkWell(
        onTap: () {
          provider.isSearchEnabled = true;
          provider.rebuild();
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: SizeConfigure.widthMultiplier! * 7,
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
      mySpacer(width: SizeConfigure.widthMultiplier! * 1.5)
    ],
  );
}

Padding myChartWidget(BuildContext context, MyWorksProvider provider,
    List chartValues, AppLocalizations language) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                height: SizeConfigure.widthMultiplier! * 24,
                width: SizeConfigure.widthMultiplier! * 30,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sections: [
                          chartData(const Color.fromARGB(255, 251, 237, 109),
                              chartValues[1], 1),
                          chartData(const Color.fromARGB(255, 111, 184, 245),
                              chartValues[2], 2),
                          chartData(const Color.fromARGB(255, 245, 123, 114),
                              chartValues[3], 3),
                        ],
                      ),
                    ),
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chartIndIcatorWidget(language.inProgress,
                    const Color.fromARGB(255, 248, 236, 127)),
                chartIndIcatorWidget(
                    language.onHold, const Color.fromARGB(255, 111, 184, 245)),
                chartIndIcatorWidget(
                    language.overdue, const Color.fromARGB(255, 245, 123, 114)),
              ],
            ),
          ],
        ),
        mySpacer(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myPieChartDetailsWidget(
                language.completed,
                chartValues[0],
                const Color.fromARGB(255, 127, 232, 131),
                Icons.check_circle,
                context),
            myPieChartDetailsWidget(
                language.inProgress,
                chartValues[1],
                const Color.fromARGB(255, 251, 237, 109),
                Icons.alarm_on,
                context),
            myPieChartDetailsWidget(
                language.onHold,
                chartValues[2],
                const Color.fromARGB(255, 111, 184, 245),
                Icons.do_not_disturb_on,
                context),
            myPieChartDetailsWidget(
                language.overdue,
                chartValues[3],
                const Color.fromARGB(255, 245, 123, 114),
                Icons.dangerous,
                context),
          ],
        ),
        mySpacer(height: 10),
      ],
    ),
  );
}

Localizations myPieChartDetailsWidget(String text, double value, Color color,
    IconData icon, BuildContext context) {
  return Localizations.override(
    context: context,
    locale: const Locale("en"),
    child: Container(
      width: SizeConfigure.widthMultiplier! * 18,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 4,
                spreadRadius: .1,
                color: Color.fromARGB(255, 230, 227, 227))
          ],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              myText(text, fontSize: .8, fontWeight: FontWeight.bold)
            ],
          ),
          myText(value.toInt().toString(), fontWeight: FontWeight.bold)
        ],
      ),
    ),
  );
}

Container myChartDetailsWidget(
    String text, IconData icon, double value, Color color) {
  return Container(
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(2),
    width: SizeConfigure.widthMultiplier! * 16,
    height: 10,
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.black,
            ),
            myText(value.toInt().toString(),
                fontSize: 1.5, fontWeight: FontWeight.bold),
          ],
        ),
        myText(text,
            fontSize: 1, fontWeight: FontWeight.bold, color: Colors.grey[600])
      ],
    ),
  );
}
