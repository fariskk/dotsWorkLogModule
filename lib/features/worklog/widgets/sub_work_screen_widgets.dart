import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/provider/sub_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/screens/add_sub_work_screen.dart';
import 'package:dots_ticcket_module/models/models.dart';
import 'package:dots_ticcket_module/services/api_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

FlutterSlider progressSliderWidget(Map workDetails, SubWorkProvider provider) {
  return FlutterSlider(
    handler: FlutterSliderHandler(
        child: const Icon(
      Icons.percent,
      size: 12,
    )),
    trackBar: const FlutterSliderTrackBar(
        activeTrackBar: BoxDecoration(color: kMainColor)),
    values: [provider.newProgress ?? workDetails["PROGRESS"].toDouble()],
    max: 100.1,
    min: workDetails["PROGRESS"].toDouble(),
    onDragCompleted: (a, value, b) {
      provider.newProgress = value;
    },
  );
}

SizedBox subWorksAttachFilesection(
    BuildContext context, SubWorkProvider provider, AppLocalizations language) {
  return SizedBox(
    height: 45,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.subWorkSttachments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () async {
                var files = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: [
                    'jpg',
                  ],
                );
                if (files != null) {
                  if (files.count > 3) {
                    mySnackBar("File count is Grater Than 3", context);
                    return;
                  }
                  for (var file in files.files) {
                    if (file.size / 1024 > 400) {
                      mySnackBar(
                          "${file.name} Size is Grater Than 400 KB", context);
                      continue;
                    }
                    provider.subWorkSttachments.add(Attachments.fromJson(
                        {"name": file.name, "path": file.path!}));
                  }

                  provider.rebuild();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(5),
                height: SizeConfigure.widthMultiplier! * 8,
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
                    mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                    Text(provider.subWorkSttachments.isEmpty
                        ? language.attachFile
                        : language.add)
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
                myText(provider.subWorkSttachments[index - 1].name,
                    maxLength: 18, fontSize: 1.4),
                IconButton(
                    onPressed: () {
                      provider.subWorkSttachments.removeAt(index - 1);
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

Row statusWidget(SubWorkProvider provider, String value) {
  return Row(
    children: [
      Checkbox(
          value: provider.status == value ? true : false,
          onChanged: (val) {
            provider.status = value;
            provider.rebuild();
          }),
      myText(value)
    ],
  );
}

Stack timeDisplayWidget(
    TimeOfDay? time, String titleText, BuildContext context) {
  return Stack(
    children: [
      SizedBox(
        height: SizeConfigure.widthMultiplier! * 12,
        width: SizeConfigure.widthMultiplier! * 24,
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
                  time != null
                      ? myText("${time.hour}:${time.minute}", fontSize: 1.8)
                      : myText("00:00", fontSize: 1.8),
                  mySpacer(width: 5),
                  time != null
                      ? const Icon(
                          Icons.cancel,
                          size: 18,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
      myText("   $titleText", fontSize: 1, fontWeight: FontWeight.w700),
    ],
  );
}

List<Widget> expandedContentWidget(Map subWorkDetails, List subWorkAttachments,
    BuildContext context, AppLocalizations language) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        myText(language.workDescription,
            fontSize: 1.6,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 162, 155, 155)),
        const Expanded(child: SizedBox()),
        const Icon(
          Icons.person,
          size: 17,
        ),
        mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
        myText(subWorkDetails["EMPLOYEE_NAME"] ?? "",
            fontSize: 1.4,
            fontWeight: FontWeight.w600,
            maxLength: 12,
            color: kMainColor),
      ],
    ),
    Text(subWorkDetails["WORK_DESCRIPTION"]),
    Visibility(
      visible: subWorkDetails["WORK_NOTS"].isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(language.notes,
              fontSize: 1.6,
              fontWeight: FontWeight.w700,
              color: const Color.fromARGB(255, 162, 155, 155)),
          Text(subWorkDetails["WORK_NOTS"]),
        ],
      ),
    ),
    Visibility(
      visible: subWorkDetails["WORK_CHALLENGES"].isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(language.blockersAndChallenges,
              fontSize: 1.6,
              fontWeight: FontWeight.w700,
              color: const Color.fromARGB(255, 162, 155, 155)),
          Text(subWorkDetails["WORK_CHALLENGES"]),
        ],
      ),
    ),
    Visibility(
      visible: subWorkAttachments.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(language.attachments,
              fontSize: 1.6,
              fontWeight: FontWeight.w700,
              color: const Color.fromARGB(255, 162, 155, 155)),
          SizedBox(
            height: SizeConfigure.widthMultiplier! * 10,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subWorkAttachments.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.white,
                    onTap: () async {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(5),
                      height: SizeConfigure.widthMultiplier! * 3,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 237, 237, 237),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_file_rounded,
                            size: SizeConfigure.widthMultiplier! * 3,
                            color: kMainColor,
                          ),
                          mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                          myText(subWorkAttachments[index]["DAILYWORK_FILE"],
                              maxLength: 18, fontSize: 1),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    )
  ];
}

Padding myExpanstionTile(
  List subWorkAttachments,
  Map subWorkDetails,
  SubWorkProvider provider,
  BuildContext context,
  AppLocalizations language,
  Map work,
  int index,
  String workId,
  String empCode,
) {
  var language = AppLocalizations.of(context)!;
  List attachmentsOfThisSubWork = [];
  for (var attachment in subWorkAttachments) {
    if (attachment["WORK_SUB_ID"] == subWorkDetails["WORK_SUB_ID"]) {
      attachmentsOfThisSubWork.add(attachment);
    }
  }
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Slidable(
      endActionPane: ActionPane(
        extentRatio: .55,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.grey[100]!,
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: myText(language.deleteWorklog, fontSize: 2.5),
                      content: myText(language.deleteWorklogDialog,
                          textOverflow: TextOverflow.visible),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: myText(language.cancel)),
                        TextButton(
                            onPressed: () async {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              provider.isLoading = true;
                              provider.rebuild();
                              var res = await ApiServices.deleteSubWork(empCode,
                                  workId, subWorkDetails["WORK_SUB_ID"]);
                              if (res.data["result"].runtimeType == bool) {
                                if (res.data["result"]) {
                                  mySnackBar("Deleted Successfully", context);
                                } else {
                                  mySnackBar("Failed To Delete", context);
                                }
                              }
                              provider.isLoading = false;
                              provider.rebuild();
                            },
                            child: myText(language.ok))
                      ],
                    );
                  });
            },
            foregroundColor: Colors.black,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            backgroundColor: Colors.grey[100]!,
            onPressed: (BuildContext context) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddSubWorkScreen(
                        isToEdit: true,
                        empCode: empCode,
                        workId: workId,
                        work: work,
                        subWorkToEdit: subWorkDetails,
                        subWorkAttachments: attachmentsOfThisSubWork,
                        subWorkId: subWorkDetails["WORK_SUB_ID"],
                      )));
            },
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: ExpansionTile(
          key: UniqueKey(),
          maintainState: true,
          onExpansionChanged: (value) {
            if (value) {
              provider.expandedTileIndex = index;

              provider.rebuild();
            } else {
              provider.expandedTileIndex = -1;
              provider.rebuild();
            }
          },
          initiallyExpanded: index == provider.expandedTileIndex,
          shape: const Border(),
          tilePadding: const EdgeInsets.all(10),
          childrenPadding: const EdgeInsets.all(10),
          collapsedBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Colors.white,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
              height: SizeConfigure.widthMultiplier! * 14,
              width: SizeConfigure.widthMultiplier! * 18,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 126, 147, 168),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: myExpanstiontileDateWidget(subWorkDetails)),
          subtitle: Localizations.override(
            locale: const Locale("en"),
            context: context,
            child: myText(
                "${to12Hours(subWorkDetails["START_TIME"])} To ${to12Hours(subWorkDetails["END_TIME"])} (${subWorkDetails["TOTAL_TIME"]} hours)",
                fontSize: 1.1,
                color: kMainColor),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: SizeConfigure.widthMultiplier! * 45,
                  child: myText(subWorkDetails["WORK_TITLE"], fontSize: 1.9)),
              myText(
                  subWorkDetails["WORK_COMPLETED_FLAG"] == true
                      ? "completed"
                      : "pending",
                  color: subWorkDetails["WORK_COMPLETED_FLAG"] == true
                      ? Colors.green
                      : Colors.orange,
                  fontSize: 1.4)
            ],
          ),
          children: expandedContentWidget(
              subWorkDetails, attachmentsOfThisSubWork, context, language),
        ),
      ),
    ),
  );
}

Column myExpanstiontileDateWidget(Map subWorkDetails) {
  return Column(
    children: [
      myText(toDDMMMYYY(subWorkDetails["CURRENT_DATE"]).split("-").first,
          fontSize: 2.5, color: Colors.white, fontWeight: FontWeight.bold),
      myText(toDDMMMYYY(subWorkDetails["CURRENT_DATE"]).split("-")[1],
          fontSize: 1.4, color: const Color.fromARGB(255, 240, 240, 240))
    ],
  );
}
