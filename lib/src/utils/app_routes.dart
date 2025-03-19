import 'package:flutter/material.dart';
import 'package:news_flutter/src/ui/pages/home_view.dart';
import 'package:news_flutter/src/ui/pages/saved_articles_view.dart';
import 'package:news_flutter/src/ui/pages/sign_in_view.dart';

class AppRoutes {
  static get home => MaterialPageRoute(
        settings: RouteSettings(name: "home"),
        builder: (context) => HomeView(),
      );

  static get signIn => MaterialPageRoute(
        settings: RouteSettings(name: "authentication"),
        builder: (context) => SignInView(),
      );

  static get savedArticles => MaterialPageRoute(
        settings: RouteSettings(name: "saved"),
        builder: (context) => SavedArticlesView(),
      );
}
