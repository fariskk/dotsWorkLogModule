import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/screens/my_sub_works_screen.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../provider/worklog_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

SizedBox myAttachFilesection(BuildContext context, WorklogProvider provider,
    int workDetailsIndex, AppLocalizations language) {
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
                    provider.attachments.add(Attachments.fromJson(
                        {"name": file.name, "path": file.path}));
                  }

                  provider.rebuild();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(5),
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
                    provider.attachments.isEmpty
                        ? Text(
                            language.attachFile,
                          )
                        : Text(language.add)
                  ],
                ),
              ),
            );
          }
          return InkWell(
            onTap: () {
              OpenFile.open(provider.attachments[index - 1].path);
            },
            child: Container(
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
            ),
          );
        }),
  );
}

Row myCircularProgressWidget(
    BuildContext context, Works workDetails, AppLocalizations language) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
          height: SizeConfigure.widthMultiplier! * 40,
          width: SizeConfigure.widthMultiplier! * 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: SizeConfigure.widthMultiplier! * 30,
                width: SizeConfigure.widthMultiplier! * 30,
                child: CircularProgressIndicator(
                  backgroundColor: const Color.fromARGB(255, 232, 228, 228),
                  strokeWidth: 22,
                  strokeCap: StrokeCap.round,
                  color: kMainColor,
                  value: workDetails.progress / 100,
                ),
              ),
              myText("${workDetails.progress}%",
                  fontSize: 1.1, fontWeight: FontWeight.bold)
            ],
          )),
      mySpacer(width: SizeConfigure.widthMultiplier! * 4),
      SizedBox(
        width: SizeConfigure.widthMultiplier! * 35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myText(language.assignedBY,
                fontSize: 1, color: Colors.grey, fontWeight: FontWeight.w700),
            myText(
              workDetails.assignedBy,
              fontSize: 1.4,
            ),
            myText(language.workGroups,
                fontSize: 1, color: Colors.grey, fontWeight: FontWeight.w700),
            myText(
              workDetails.company,
              fontSize: 1.4,
            ),
            Visibility(
              visible: workDetails.dependencies.isNotEmpty,
              child: Column(
                children: [
                  myText(language.dependencies,
                      fontSize: 1,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ),
            Text(
              workDetails.dependencies,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      )
    ],
  );
}

Visibility myWorkAttacmentsDisplayWidget(
    Works workDetails, BuildContext context) {
  return Visibility(
    visible: workDetails.attachments.isNotEmpty,
    child: SizedBox(
      height: SizeConfigure.widthMultiplier! * 9,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: workDetails.attachments.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await OpenFile.open(workDetails.attachments[index].path);
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.all(5),
                height: 35,
                width: SizeConfigure.widthMultiplier! * 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 237, 237),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file_rounded,
                      size: 15,
                      color: kMainColor,
                    ),
                    mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
                    myText(workDetails.attachments[index].name,
                        maxLength: 18, fontSize: 1),
                  ],
                ),
              ),
            );
          }),
    ),
  );
}

Row myStatusSection(
    WorklogProvider provider, BuildContext context, AppLocalizations language) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: SizedBox(
          height: SizeConfigure.widthMultiplier! * 14,
          child: DropdownButtonFormField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: provider.selectedStatus,
              items: provider.statusTypes
                  .map((e) => DropdownMenuItem(
                        onTap: () {
                          provider.selectedStatus = e;
                          provider.rebuild();
                        },
                        value: e,
                        child: myText(e),
                      ))
                  .toList(),
              onChanged: (value) {}),
        ),
      ),
      Visibility(
        visible: provider.selectedStatus == "Assign To" ? true : false,
        child: Container(
            margin: const EdgeInsets.only(left: 10),
            height: SizeConfigure.widthMultiplier! * 14,
            width: SizeConfigure.widthMultiplier! * 40,
            child: myTypeHeadDropDown(
                items: Provider.of<CommonProvider>(context, listen: false)
                    .employees,
                hintText: "Employee",
                labelText: language.assignedBY,
                value: provider.assignTo,
                onSelected: (asiignedBy) {
                  provider.assignTo = asiignedBy;
                  provider.rebuild();
                },
                onCancel: () {
                  provider.assignTo = null;

                  provider.rebuild();
                })),
      ),
    ],
  );
}

Container myClientAndDueDateSection(BuildContext context,
    WorklogProvider provider, Works workDetails, AppLocalizations language) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
          blurRadius: 5,
          color: Color.fromARGB(255, 239, 239, 239),
          spreadRadius: 1,
          offset: Offset(0, 3.5)),
    ]),
    child: Row(
      children: [
        SizedBox(
          width: SizeConfigure.widthMultiplier! * 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: SizeConfigure.widthMultiplier! * 10.4,
                width: SizeConfigure.widthMultiplier! * 10.4,
                decoration: const BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Center(
                  child: Image.asset(
                    "assets/icons/user.png",
                    color: Colors.white,
                    width: SizeConfigure.widthMultiplier! * 6,
                    height: SizeConfigure.widthMultiplier! * 4,
                  ),
                ),
              ),
              mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mySpacer(height: SizeConfigure.widthMultiplier! * 1),
                  myText(language.client, color: Colors.grey, fontSize: 1.0),
                  SizedBox(
                    width: SizeConfigure.widthMultiplier! * 25,
                    child: myText(workDetails.client, fontSize: 1.2),
                  ),
                  mySpacer(height: SizeConfigure.widthMultiplier! * 1),
                  Row(
                    children: [
                      const Icon(
                        Icons.call,
                        size: 12,
                      ),
                      mySpacer(width: SizeConfigure.widthMultiplier! * .9),
                      myText("Email", fontSize: 1, color: kMainColor),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: SizeConfigure.widthMultiplier! * .3,
          height: SizeConfigure.widthMultiplier! * 12,
          color: Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: SizeConfigure.widthMultiplier! * 35,
          child: Row(
            children: [
              Container(
                height: SizeConfigure.widthMultiplier! * 10.4,
                width: SizeConfigure.widthMultiplier! * 10.4,
                decoration: const BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Center(
                  child: Image.asset(
                    "assets/icons/calendar.png",
                    color: Colors.white,
                    width: SizeConfigure.widthMultiplier! * 5,
                    height: SizeConfigure.widthMultiplier! * 5,
                  ),
                ),
              ),
              mySpacer(width: SizeConfigure.widthMultiplier! * 1.5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mySpacer(height: SizeConfigure.widthMultiplier! * 1),
                  myText(language.dueDate, color: Colors.grey, fontSize: 1),
                  mySpacer(height: SizeConfigure.widthMultiplier! * .2),
                  myText(toDDMMMYYY(workDetails.endDate), fontSize: 1.2),
                  mySpacer(height: SizeConfigure.widthMultiplier! * .7),
                  myText(
                      getDateDiffrence(workDetails.endDate) > 0
                          ? "${getDateDiffrence(workDetails.endDate)} ${language.daysLeft}"
                          : language.overdue,
                      fontSize: .9,
                      color: Colors.red)
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

AppBar myAppBar(WorklogProvider provider, BuildContext context,
    Works workDetails, AppLocalizations language) {
  return AppBar(
    backgroundColor: kMainColor,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: myText(workDetails.id, fontSize: 2.1, color: Colors.white),
    actions: [
      MaterialButton(
        shape: const StadiumBorder(),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MySubWorksScreen(
                        subWorkId: workDetails.subWork,
                        work: workDetails,
                      )));
        },
        child: Row(
          children: [
            const Icon(Icons.add),
            myText(language.dailyLog),
          ],
        ),
      ),
      mySpacer(width: SizeConfigure.widthMultiplier! * 2),
      myLanguageButton(),
      mySpacer(width: SizeConfigure.widthMultiplier! * 3),
    ],
  );
}

Color getTextColor(String text) {
  switch (text) {
    case "Low Priority":
      return Colors.green;
    case "Mid Priority":
      return Colors.yellow;
    case "High Priority":
      return Colors.red;
    case "Completed":
      return const Color.fromARGB(255, 124, 251, 128);
    case "In Progress":
      return const Color.fromARGB(255, 202, 186, 41);
    case "On Hold":
      return const Color.fromARGB(255, 133, 198, 252);
    default:
      return Colors.black;
  }
}
