import 'package:dots_ticcket_module/common/colors.dart';
import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

Text myText(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    int? maxLength,
    TextOverflow textOverflow = TextOverflow.ellipsis}) {
  if (maxLength != null && text.length > maxLength) {
    if (maxLength < 9) {
      throw "maxLengh Must Be Grater Than 8";
    }
    List listedText = text.split("");
    String shortedString =
        "${listedText.getRange(0, maxLength - 8).join()}...${listedText.getRange(text.length - 5, text.length).join()}";
    text = shortedString;
  }
  return Text(
    text,
    overflow: textOverflow,
    style: GoogleFonts.manrope(
        color: color,
        fontSize: fontSize != null
            ? SizeConfigure.textMultiplier! * fontSize
            : SizeConfigure.textMultiplier! * 1.6,
        fontWeight: fontWeight),
  );
}

Widget mySpacer({double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

void mySnackBar(
  String text,
  BuildContext context,
) {
  Fluttertoast.showToast(
      msg: text, backgroundColor: const Color.fromARGB(255, 52, 52, 52));
}

Future<bool> myExitDialog(
  BuildContext context,
  AppLocalizations language,
) async {
  bool yesOrNo = false;
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: myText(language.exitDialog, fontSize: 1.8),
          actions: [
            TextButton(
                onPressed: () {
                  yesOrNo = false;
                  Navigator.pop(context);
                },
                child: Text(language.no)),
            TextButton(
                onPressed: () {
                  yesOrNo = true;
                  Navigator.pop(context);
                },
                child: Text(language.yes))
          ],
        );
      });
  return yesOrNo;
}

TypeAheadField myTypeHeadDropDown(
    {required List<String> items,
    required String hintText,
    required String labelText,
    required String? value,
    required Function onSelected,
    required Function onCancel,
    InputBorder? inputBorder = const OutlineInputBorder()}) {
  return TypeAheadField(
    constraints: const BoxConstraints(maxHeight: 200),
    suggestionsCallback: (search) {
      return items
          .where(
              (element) => element.toUpperCase().contains(search.toUpperCase()))
          .toList();
    },
    builder: (context, controller, focusNode) {
      controller.text = value ?? "";

      controller.addListener(
        () {
          if (items.contains(controller.text)) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
      );
      return FocusScope(
        child: Focus(
          onFocusChange: (value) {
            if (!value) {
              if (!items.contains(controller.text)) {
                onCancel();
              }
            }
          },
          child: TextField(
              onChanged: (value) {
                if (items.contains(value)) {
                  onSelected(value);
                }
              },
              readOnly: items.contains(controller.text),
              style: TextStyle(fontSize: SizeConfigure.textMultiplier! * 1.8),
              controller: TextEditingController(
                  text: controller.text.split("-").last.replaceAll("_", " ")),
              focusNode: focusNode,
              decoration: InputDecoration(
                suffixIcon: Visibility(
                    visible: controller.text.isNotEmpty,
                    child: IconButton(
                        onPressed: () {
                          onCancel();
                        },
                        icon: const Icon(Icons.cancel))),
                border: inputBorder,
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: labelText,
                labelStyle:
                    TextStyle(fontSize: SizeConfigure.textMultiplier! * 1.6),
                hintText: hintText,
              )),
        ),
      );
    },
    itemBuilder: (context, sugession) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: myText(
            sugession.toString().split("-").last.replaceAll("_", "  "),
            textOverflow: TextOverflow.visible),
      );
    },
    onSelected: (workGroup) {
      onSelected(workGroup);
    },
  );
}

TextField myTextfield(String hintText,
    {int? minLines, int maxLines = 1, TextEditingController? controller}) {
  return TextField(
    style: TextStyle(fontSize: SizeConfigure.textMultiplier! * 1.8),
    controller: controller,
    minLines: minLines,
    maxLines: maxLines,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: myText(
          hintText,
        ),
        border: const OutlineInputBorder()),
  );
}

String getDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

int getDateDiffrence(String date) {
  List dateParts = date.split("-");
  int days = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]),
          int.parse(dateParts[0]))
      .difference(DateTime.now())
      .inDays;

  return days + 1;
}

String getMountString(String mount) {
  switch (mount) {
    case "1":
      return "Jan";
    case "2":
      return "Feb";
    case "3":
      return "Mar";
    case "4":
      return "Apr";
    case "5":
      return "May";
    case "6":
      return "Jun";
    case "7":
      return "Jul";
    case "8":
      return "Aug";
    case "9":
      return "Sep";
    case "10":
      return "Oct";
    case "11":
      return "Nov";
    case "12":
      return "Des";
    default:
      return "error";
  }
}

String to12Hours(String time) {
  String hour = time.split(":").first;
  int intHour = int.parse(hour);
  if (intHour > 12) {
    return "${(intHour - 12)}:${time.split(":").last}";
  }
  return time;
}

String toDDMMMYYY(String date) {
  List dateParts = date.split("-");
  return "${dateParts[0]}-${getMountString(dateParts[1])}-${dateParts[2]}"
      .toUpperCase();
}

String dateTimetoDDMMYYY(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

class AutoNumberingTextField extends StatefulWidget {
  AutoNumberingTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.minLines = 1,
      this.maxLines = 1});
  String hintText;
  int minLines;
  int maxLines;
  TextEditingController controller;
  @override
  State<AutoNumberingTextField> createState() => _TestState();
}

class _TestState extends State<AutoNumberingTextField> {
  String previusText = "";

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateNumbering);
  }

  void _updateNumbering() {
    String text = widget.controller.text;
    int j = text.split("\n").length;
    if (text == "1.") {
      text = "1. ";
    }
    if ((text.length < previusText.length) && text.length > 2) {
      if (text[text.length - 1] == "." && text[text.length - 3] == "\n") {
        text = text.substring(0, text.length - 3);
      }
    } else {
      if (text.isNotEmpty && text[text.length - 1] == "\n" && text.length > 2) {
        if (text[text.length - 3] == ".") {
          text = text.substring(0, text.length - 1);
        } else {
          text = "$text$j. ";
        }
      }
    }

    String updatedText = text;
    previusText = updatedText;
    widget.controller.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateNumbering);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          if (!focus) {
            if (widget.controller.text == "1. ") {
              widget.controller.removeListener(_updateNumbering);
              widget.controller.text = "";
            }
            List lines = widget.controller.text.split("\n");
            if (lines.last.length == 3) {
              lines.removeAt(lines.length - 1);
              widget.controller.text = lines.join("\n");
            }
          }
          if (focus) {
            widget.controller.addListener(_updateNumbering);
            if (widget.controller.text == "") {
              widget.controller.value = const TextEditingValue(
                text: "1. ",
                selection: TextSelection.collapsed(offset: 3),
              );
            }
          }
        },
        child: TextField(
          style: TextStyle(fontSize: SizeConfigure.textMultiplier! * 1.8),
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontWeight: FontWeight.normal),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: myText(widget.hintText)),
        ),
      ),
    );
  }
}

PopupMenuButton<dynamic> myLanguageButton() {
  return PopupMenuButton(
      child: const Icon(
        Icons.language,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        final commonProvider =
            Provider.of<CommonProvider>(context, listen: false);
        return [
          PopupMenuItem(
              child: myText("English"),
              onTap: () {
                commonProvider.language = const Locale("en");
                commonProvider.rebuild();
              }),
          PopupMenuItem(
            child: myText("عربي"),
            onTap: () {
              commonProvider.language = const Locale("ar");
              commonProvider.rebuild();
            },
          ),
        ];
      });
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: myText("Loading...", fontSize: 2.5, color: Colors.white),
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
        child: Center(
          child: SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset("assets/animations/loading.json")),
        ),
      ),
    );
  }
}

Widget loadingWidget(BuildContext context) {
  return Container(
    color: Colors.transparent,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: SizedBox(
          height: 100,
          width: 100,
          child: Lottie.asset("assets/animations/loading.json")),
    ),
  );
}

getPriorityInString(bool low, bool mid, bool high) {
  if (low) {
    return "Low";
  } else if (mid) {
    return "Mid";
  } else {
    return "High";
  }
}
