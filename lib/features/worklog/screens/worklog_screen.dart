import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/provider/worklog_provider.dart';
import 'package:dots_ticcket_module/features/worklog/widgets/worklog_screen_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class WorklogScreen extends StatefulWidget {
  const WorklogScreen({super.key, required this.workDetailsIndex});
  final int workDetailsIndex;

  @override
  State<WorklogScreen> createState() => _WorklogScreenState();
}

class _WorklogScreenState extends State<WorklogScreen> {
  bool isCommentsExpanded = false;

  TextEditingController commentsController = TextEditingController();
  @override
  void initState() {
    Provider.of<WorklogProvider>(context, listen: false).clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorklogProvider>(
      builder: (context, provider, child) {
        Works workDetails = dotsData.works[widget.workDetailsIndex];
        var language = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: myAppBar(provider, context, workDetails, language),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: SizeConfigure.widthMultiplier! * 60,
                                child: myText(workDetails.taskName,
                                    fontSize: 3, fontWeight: FontWeight.w600),
                              ),
                              myText(workDetails.priority,
                                  color: getTextColor(workDetails.priority),
                                  fontSize: 1.3,
                                  fontWeight: FontWeight.bold)
                            ],
                          ),

                          myText(
                              "${toDDMMMYYY(workDetails.startDate)} -- ${toDDMMMYYY(workDetails.endDate)}",
                              fontSize: 1,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[500]),
                          //circular progress section
                          myCircularProgressWidget(
                              context, workDetails, language),
                          //client and assignedBy section
                          myClientAndDueDateSection(
                              context, provider, workDetails, language),
                          mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                          if (workDetails.comments.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                myText(language.comments,
                                    fontSize: 2.1, fontWeight: FontWeight.w700),
                                mySpacer(height: 5),
                                myMoreText(workDetails.comments, provider),
                              ],
                            ),
                          Visibility(
                            visible: workDetails.attachments.isNotEmpty,
                            child: myText(language.attachments,
                                fontSize: 2.1, fontWeight: FontWeight.w700),
                          ),
                          myWorkAttacmentsDisplayWidget(workDetails, context),
                        ],
                      ),
                    ),

                    mySpacer(height: 15),
                    //status section
                    Container(
                      padding:
                          EdgeInsets.all(SizeConfigure.widthMultiplier! * 4),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myText(language.selectStatus,
                              fontSize: 2.1, fontWeight: FontWeight.w700),
                          mySpacer(height: SizeConfigure.widthMultiplier! * 2),

                          myStatusSection(provider, context, language),
                          mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                          AutoNumberingTextField(
                            hintText: language.comments,
                            controller: commentsController,
                            minLines: 2,
                            maxLines: 3,
                          ),

                          mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                          myAttachFilesection(context, provider,
                              widget.workDetailsIndex, language),
                          mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                          //submit button
                          MaterialButton(
                            onPressed: () {},
                            minWidth: MediaQuery.of(context).size.width,
                            color: kMainColor,
                            shape: const StadiumBorder(),
                            height: SizeConfigure.widthMultiplier! * 10,
                            child: myText(
                                provider.assignTo == null ? "Submit" : "Assign",
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: const SizedBox(),
    );
  }

  Widget myMoreText(String text, WorklogProvider provider) {
    List textLines = text.split("\n");
    if (text.split("\n").length > 2 && !isCommentsExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          myText(textLines[0] + "\n" + textLines[1],
              fontSize: 1.5, textOverflow: TextOverflow.visible),
          InkWell(
              onTap: () {
                isCommentsExpanded = true;
                provider.rebuild();
              },
              child: myText("More...", color: Colors.blue))
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        myText(text, fontSize: 1.5, textOverflow: TextOverflow.visible),
        textLines.length > 2
            ? InkWell(
                onTap: () {
                  isCommentsExpanded = false;
                  provider.rebuild();
                },
                child: myText("Less", color: Colors.blue))
            : const SizedBox()
      ],
    );
  }
}
