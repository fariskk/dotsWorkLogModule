import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/provider/sub_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/screens/my_sub_works_screen.dart';
import 'package:dots_ticcket_module/features/worklog/widgets/sub_work_screen_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AddSubWorkScreen extends StatefulWidget {
  AddSubWorkScreen(
      {super.key,
      this.isToEdit = false,
      required this.subWorkId,
      this.subWorkToEdit,
      required this.work});

  bool isToEdit;
  String subWorkId;
  SubWorks? subWorkToEdit;
  Works work;
  @override
  State<AddSubWorkScreen> createState() => _AddSubWorkScreenState();
}

class _AddSubWorkScreenState extends State<AddSubWorkScreen> {
  TextEditingController workTitleController = TextEditingController();
  TextEditingController workDescriptionController = TextEditingController();

  TextEditingController notesController = TextEditingController();

  TextEditingController blockersController = TextEditingController();

  bool canPop = false;
  @override
  void initState() {
    fillEditDetails(Provider.of<SubWorkProvider>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        canPop = await myExitDialog(context, language);
        if (canPop && context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MySubWorksScreen(
                        work: widget.work,
                        subWorkId: widget.subWorkId,
                      )));
          Navigator.pop(context);
        }
      },
      child: Consumer<SubWorkProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: kMainColor,
            appBar: AppBar(
              backgroundColor: kMainColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () async {
                  canPop = await myExitDialog(context, language);
                  if (canPop && context.mounted) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySubWorksScreen(
                                  work: widget.work,
                                  subWorkId: widget.subWorkId,
                                )));
                    Navigator.pop(context);
                  }
                },
              ),
              title:
                  myText(language.dailyLog, fontSize: 2, color: Colors.white),
              actions: [
                myLanguageButton(),
                mySpacer(width: SizeConfigure.widthMultiplier! * 4.5)
              ],
            ),
            body: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mySpacer(height: SizeConfigure.widthMultiplier! * 4),
                      myText(
                        language.workDetails,
                        fontSize: 1.9,
                        fontWeight: FontWeight.bold,
                      ),
                      const Divider(),

                      mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                      //work title dropdown
                      myTypeHeadDropDown(
                          items: Provider.of<CommonProvider>(context,
                                  listen: false)
                              .workTitle,
                          hintText: language.workTitle,
                          labelText: language.workTitle,
                          value: provider.workTitle,
                          onSelected: (workTitle) {
                            provider.workTitle = workTitle;
                            provider.rebuild();
                          },
                          onCancel: () {
                            provider.workTitle = null;

                            provider.rebuild();
                          }),

                      mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                      //work description field
                      myTextfield(language.workDescription,
                          controller: workDescriptionController),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3.2),
                      //time section
                      SizedBox(
                        height: SizeConfigure.widthMultiplier! * 12,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());

                                  if (time != null) {
                                    provider.startTime = time;
                                  }
                                  provider.rebuild();
                                },
                                child: timeDisplayWidget(provider.startTime,
                                    language.startTime, context)),
                            myText("TO",
                                fontSize: 1.8, fontWeight: FontWeight.w500),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                if (time != null) {
                                  provider.endTime = time;
                                }
                                provider.rebuild();
                              },
                              child: timeDisplayWidget(
                                  provider.endTime, language.endTime, context),
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  height: SizeConfigure.widthMultiplier! * 12,
                                  width: SizeConfigure.widthMultiplier! * 25,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height:
                                          SizeConfigure.widthMultiplier! * 10.6,
                                      width:
                                          SizeConfigure.widthMultiplier! * 42,
                                      decoration: BoxDecoration(
                                          color: kMainColor.withOpacity(.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                        child: myText(
                                            provider.startTime != null &&
                                                    provider.endTime != null
                                                ? getTotalTime(
                                                    provider.startTime!,
                                                    provider.endTime!,
                                                    provider)
                                                : "0:0",
                                            fontSize: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                myText("   ${language.totalTime}",
                                    fontSize: 1, fontWeight: FontWeight.w700),
                              ],
                            ),
                          ],
                        ),
                      ),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                      //status section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(language.status,
                              fontSize: 2, fontWeight: FontWeight.w600),
                          statusWidget(provider, "In Progress"),
                          statusWidget(provider, "Completed"),
                        ],
                      ),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                      //notes field
                      AutoNumberingTextField(
                        hintText: language.notes,
                        controller: notesController,
                        maxLines: 3,
                      ),
                      //progress section
                      widget.isToEdit
                          ? SizedBox(
                              height: SizeConfigure.widthMultiplier! * 2,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText(language.progress,
                                    fontSize: 1.7,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(
                                        255, 103, 100, 100)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      SizeConfigure.widthMultiplier! * 36,
                                  child: progressSliderWidget(
                                      widget.work, provider),
                                ),
                              ],
                            ),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 1),
                      //blocers and challeges field
                      AutoNumberingTextField(
                        hintText: language.blockersAndChallenges,
                        controller: blockersController,
                        minLines: 2,
                        maxLines: 3,
                      ),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                      // attach file section
                      subWorksAttachFilesection(context, provider, language),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                      //submit section
                      MaterialButton(
                        onPressed: () async {
                          if (widget.isToEdit) {
                            if (await provider.updateWorklog(
                                  widget.subWorkToEdit!,
                                  provider.workTitle,
                                  workDescriptionController.text,
                                  notesController.text,
                                  blockersController.text,
                                  context,
                                  widget.subWorkId,
                                ) &&
                                context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySubWorksScreen(
                                          work: widget.work,
                                          subWorkId: widget.subWorkId)));
                              Navigator.pop(context);
                            }
                          } else {
                            if (await provider.submitWorklog(
                                    provider.workTitle,
                                    workDescriptionController.text,
                                    notesController.text,
                                    blockersController.text,
                                    context,
                                    widget.subWorkId,
                                    widget.work.id) &&
                                context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySubWorksScreen(
                                          work: widget.work,
                                          subWorkId: widget.subWorkId)));
                              Navigator.pop(context);
                            }
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        color: kMainColor,
                        shape: const StadiumBorder(),
                        height: SizeConfigure.widthMultiplier! * 10,
                        child: myText(
                            widget.isToEdit ? language.update : language.submit,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void fillEditDetails(SubWorkProvider provider) {
    provider.clear();
    if (widget.isToEdit) {
      provider.workTitle = widget.subWorkToEdit!.taskName;
      workTitleController.text = widget.subWorkToEdit!.taskName;
      workDescriptionController.text = widget.subWorkToEdit!.taskDecription;
      provider.status = widget.subWorkToEdit!.status;
      notesController.text = widget.subWorkToEdit!.notes;
      provider.startTime = toTimeOfDay(widget.subWorkToEdit!.startTime);
      provider.endTime = toTimeOfDay(widget.subWorkToEdit!.endTime);
      blockersController.text = widget.subWorkToEdit!.blockersAndChallanges;
      provider.subWorkSttachments = widget.subWorkToEdit!.attachments;
    }
  }
}

TimeOfDay toTimeOfDay(String timeInString) {
  List timeParts = timeInString.split(":");
  return TimeOfDay(
      hour: int.parse(timeParts.first), minute: int.parse(timeParts.last));
}

String getTotalTime(TimeOfDay start, TimeOfDay end, SubWorkProvider provider) {
  DateTime now = DateTime.now();
  double diffrence =
      DateTime(now.year, now.month, now.day, end.hour, end.minute)
          .difference(
              DateTime(now.year, now.month, now.day, start.hour, start.minute))
          .inMinutes
          .toDouble();
  if ((diffrence / 60) < 0) {
    diffrence = diffrence + 60 * 24;
  }
  String whole = (diffrence / 60).toString().split(".").first;
  String fraction =
      ".${(diffrence / 60).toString().split(".").last.substring(0, (diffrence / 60).toString().split(".").last.length > 2 ? 2 : 1)}";
  // String totalTime =
  //     "${(diffrence / 60).toString().split(".").first}.${(diffrence / 60).toString().split(".").last.substring(0, 1)}";
  provider.totalTime =
      double.parse(whole + (fraction.length == 1 ? "${fraction}0" : fraction));
  return whole + (fraction.length == 2 ? "${fraction}0" : fraction);
}
