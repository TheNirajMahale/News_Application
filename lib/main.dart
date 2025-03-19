import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter/firebase_options.dart';
import 'package:news_flutter/src/ui/pages/home_view.dart';
import 'package:news_flutter/src/utils/constants.dart';
import 'package:news_flutter/src/utils/theme.dart';
import 'package:sp_util/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // The entry point of the application, the MyApp widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeView(),
      title: AppConstants.appName,
      theme: AppTheme.buildTheme(brightness: Brightness.light),
      darkTheme: AppTheme.buildTheme(brightness: Brightness.dark),
    );
  }
}
