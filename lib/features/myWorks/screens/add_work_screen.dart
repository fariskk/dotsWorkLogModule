import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/screens/my_works_screen.dart';
import 'package:dots_ticcket_module/features/myWorks/widgets/my_works_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AddWorkScreen extends StatefulWidget {
  AddWorkScreen({super.key, this.workToEdit, this.isToEdit = false});
  bool isToEdit;
  Works? workToEdit;
  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  TextEditingController workIdController = TextEditingController();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  TextEditingController commentsController = TextEditingController();
  TextEditingController dependenciesController = TextEditingController();
  bool canPop = false;
  @override
  void initState() {
    var provider = Provider.of<MyWorksProvider>(context, listen: false);
    provider.clear();
    if (widget.isToEdit) {
      fillEditinitialValues(provider);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWorksProvider>(
      builder: (context, provider, child) {
        var language = AppLocalizations.of(context)!;
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
                          builder: (context) => const MyWorksScreen()));
                  Navigator.pop(context);
                }
              },
            ),

            //title
            title:
                myText(language.createWork, fontSize: 2.5, color: Colors.white),
            actions: [
              myLanguageButton(),
              mySpacer(width: SizeConfigure.widthMultiplier! * 4.5)
            ],
          ),
          body: PopScope(
            canPop: canPop,
            onPopInvokedWithResult: (value, dynamic) async {
              canPop = await myExitDialog(context, language);
              if (canPop && context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyWorksScreen()));
                Navigator.pop(context);
              }
            },
            child: InkWell(
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
                      mySpacer(height: 20),

                      myText(language.workDetails,
                          fontSize: 2, fontWeight: FontWeight.bold),
                      const Divider(),
                      mySpacer(height: 10),
                      myTypeHeadDropDown(
                          value: provider.selectedWorkGroup ?? "",
                          hintText: language.workGroups,
                          items: Provider.of<CommonProvider>(context,
                                  listen: false)
                              .companyes,
                          labelText: language.workGroups,
                          onCancel: () {
                            provider.selectedWorkGroup = null;

                            provider.rebuild();
                          },
                          onSelected: (workGroup) {
                            provider.selectedWorkGroup = workGroup;

                            provider.rebuild();
                          }),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                      //work id field
                      myTextfield(language.workId,
                          controller: workIdController),
                      mySpacer(height: SizeConfigure.widthMultiplier! * 3.2),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //assigned by section
                          myAssignedByDropDown(provider, language, context),
                          //client section
                          myClientdropDown(context, provider, language),
                        ],
                      ),
                      mySpacer(height: 15),
                      //taskname field
                      myTextfield(language.taskName,
                          controller: taskNameController),
                      mySpacer(height: 10),
                      //date section
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: myDateWidget(context, provider, language),
                      ),
                      //update progress slider
                      widget.isToEdit
                          ? updateProgressWidget(context, provider, language)
                          : mySpacer(height: 15),

                      //dependencies section

                      AutoNumberingTextField(
                        hintText: language.dependencies,
                        controller: dependenciesController,
                        maxLines: 3,
                      ),
                      mySpacer(height: 10),
                      //priority section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(language.priority,
                              fontSize: 2, fontWeight: FontWeight.w600),
                          myPriorityWidget("Low", provider),
                          myPriorityWidget("Mid", provider),
                          myPriorityWidget("High", provider),
                        ],
                      ),
                      mySpacer(height: 10),
                      //Reason Field
                      Visibility(
                        visible: widget.isToEdit,
                        child: AutoNumberingTextField(
                          hintText: "Reason For Change",
                          controller: reasonController,
                          maxLines: 3,
                        ),
                      ),
                      mySpacer(height: 15),
                      //comments field
                      AutoNumberingTextField(
                        hintText: language.comments,
                        controller: commentsController,
                        minLines: 2,
                        maxLines: 3,
                      ),
                      mySpacer(height: 10),
                      addWorkAttachFilesection(context, provider, language),
                      mySpacer(height: 10),
                      MaterialButton(
                        onPressed: () async {
                          if (widget.isToEdit) {
                            if (await provider.update(
                                widget.workToEdit!,
                                workIdController.text,
                                taskNameController.text,
                                commentsController.text,
                                dependenciesController.text,
                                context,
                                reasonController.text)) {
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyWorksScreen()),
                                    (route) => false);
                              }
                            }
                          } else {
                            if (await provider.submit(
                                workIdController.text,
                                taskNameController.text,
                                commentsController.text,
                                dependenciesController.text,
                                context)) {
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyWorksScreen()),
                                    (route) => false);
                              }
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
                      mySpacer(height: 15)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void fillEditinitialValues(
    MyWorksProvider provider,
  ) {
    workIdController.text = widget.workToEdit!.id;
    taskNameController.text = widget.workToEdit!.taskName;
    commentsController.text = widget.workToEdit!.comments;
    provider.assignedBy = widget.workToEdit!.assignedBy;
    provider.client = widget.workToEdit!.client;

    dependenciesController.text = widget.workToEdit!.dependencies;
    provider.startDate = toDateTime(widget.workToEdit!.startDate);
    provider.endDate = toDateTime(widget.workToEdit!.endDate);
    provider.selectedWorkGroup = widget.workToEdit!.company;

    provider.selectedPriority =
        widget.workToEdit!.priority.toString().split(" ").first;
    provider.attachments = widget.workToEdit!.attachments;
  }
}

DateTime toDateTime(String dateInString) {
  List dateParts = dateInString.split("/");
  return DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]),
      int.parse(dateParts[0]));
}

class Employee {
  final String name;
  final int id;

  Employee({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
