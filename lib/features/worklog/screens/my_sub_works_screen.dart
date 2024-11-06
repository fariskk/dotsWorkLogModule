import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/provider/sub_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/screens/add_sub_work_screen.dart';
import 'package:dots_ticcket_module/features/worklog/widgets/sub_work_screen_widgets.dart';
import 'package:dots_ticcket_module/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MySubWorksScreen extends StatefulWidget {
  const MySubWorksScreen(
      {super.key,
      required this.work,
      required this.workId,
      required this.empCode});
  final Map work;
  final String workId;
  final String empCode;

  @override
  State<MySubWorksScreen> createState() => _MySubWorksScreenState();
}

class _MySubWorksScreenState extends State<MySubWorksScreen> {
  ExpansionTileController epansionTileController = ExpansionTileController();
  @override
  void initState() {
    Provider.of<SubWorkProvider>(context, listen: false).clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return Consumer<SubWorkProvider>(
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: myText(widget.workId, fontSize: 2, color: Colors.white),
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
                children: [
                  mySpacer(height: SizeConfigure.widthMultiplier! * 3),
                  FutureBuilder(
                      future: ApiServices.getAllSubWorks(
                          widget.empCode, widget.workId),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List subWorks = snapshot.data.data["result"][0];
                          List subWorkAttachments =
                              snapshot.data.data["result"][1];

                          return Expanded(
                            child: subWorks.isEmpty
                                ? Center(
                                    child: Image.asset(
                                      "assets/icons/folder.png",
                                      height:
                                          SizeConfigure.widthMultiplier! * 20,
                                      width:
                                          SizeConfigure.widthMultiplier! * 30,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: subWorks.length,
                                    itemBuilder: (context, index) {
                                      Map subWorkDetails = subWorks[index];

                                      //expanstion tile
                                      return myExpanstionTile(
                                          subWorkAttachments,
                                          subWorkDetails,
                                          provider,
                                          context,
                                          language,
                                          widget.work,
                                          index,
                                          widget.workId,
                                          widget.empCode);
                                    }),
                          );
                        }
                        return Expanded(child: loadingWidget(context));
                      }),
                  mySpacer(height: SizeConfigure.widthMultiplier! * 2),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kMainColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSubWorkScreen(
                              empCode: widget.empCode,
                              workId: widget.workId,
                              work: widget.work,
                            )));
              },
              child: const Icon(
                Icons.post_add,
                size: 28,
                color: Colors.white,
              ),
            ));
      },
    );
  }
}
