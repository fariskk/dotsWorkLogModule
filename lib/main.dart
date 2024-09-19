import 'package:dots_ticcket_module/common/size_configure.dart';
import 'package:dots_ticcket_module/common/common_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/provider/my_works_provider.dart';
import 'package:dots_ticcket_module/features/myWorks/screens/my_works_screen.dart';
import 'package:dots_ticcket_module/features/worklog/provider/sub_works_provider.dart';
import 'package:dots_ticcket_module/features/worklog/provider/worklog_provider.dart';
import 'package:dots_ticcket_module/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorklogProvider()),
        ChangeNotifierProvider(create: (context) => MyWorksProvider()),
        ChangeNotifierProvider(create: (context) => SubWorkProvider()),
        ChangeNotifierProvider(create: (context) => CommonProvider())
      ],
      child: Consumer<CommonProvider>(builder: (context, provider, child) {
        return MaterialApp(
          locale: provider.language,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizeConfigure().init(constraints, orientation);
                return const MyWorksScreen();
              },
            );
          }),
        );
      }),
    );
  }
}
