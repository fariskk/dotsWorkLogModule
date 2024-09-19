import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/common.dart';
import 'package:dots_ticcket_module/features/worklog/provider/sub_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/screens/add_sub_work_screen.dart';
import 'package:dots_ticcket_module/features/worklog/widgets/sub_work_screen_widgets.dart';
import 'package:dots_ticcket_module/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MySubWorksScreen extends StatefulWidget {
  const MySubWorksScreen(
      {super.key, required this.work, required this.subWorkId});
  final Works work;
  final String subWorkId;

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
            title: myText(widget.work.id, fontSize: 2, color: Colors.white),
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
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(widget.subWorkId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List data = snapshot.data.docs;

                        dotsData.subWorks.clear();
                        for (var element in data) {
                          dotsData.subWorks
                              .add(SubWorks.fromJson(element.data()));
                        }

                        return Expanded(
                          child: dotsData.subWorks.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    "assets/icons/folder.png",
                                    height: SizeConfigure.widthMultiplier! * 20,
                                    width: SizeConfigure.widthMultiplier! * 30,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: dotsData.subWorks.length,
                                  itemBuilder: (context, index) {
                                    SubWorks subWorkDetails =
                                        dotsData.subWorks[index];

                                    //expanstion tile
                                    return myExpanstionTile(
                                        subWorkDetails,
                                        widget.subWorkId,
                                        provider,
                                        context,
                                        language,
                                        widget.work,
                                        index);
                                  }),
                        );
                      }
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
                mySpacer(height: SizeConfigure.widthMultiplier! * 2),
              ],
            ),
          ),
          floatingActionButton: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("works")
                  .doc(widget.work.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data["progress"] != 100) {
                  return FloatingActionButton(
                    backgroundColor: kMainColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSubWorkScreen(
                                    subWorkId: widget.subWorkId,
                                    work: widget.work,
                                  )));
                    },
                    child: const Icon(
                      Icons.post_add,
                      size: 28,
                      color: Colors.white,
                    ),
                  );
                }
                return const SizedBox();
              }),
        );
      },
    );
  }
}
