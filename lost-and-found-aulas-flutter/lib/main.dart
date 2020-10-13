import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lost_and_found/views/about_page.dart';
import 'package:lost_and_found/views/found_page.dart';
import 'package:lost_and_found/views/home_page.dart';
import 'package:lost_and_found/views/lost_object_detail_page.dart';
import 'package:lost_and_found/views/profile_page.dart';
import 'package:lost_and_found/views/root_page.dart';
import 'package:lost_and_found/views/sign_in_page.dart';
import 'package:lost_and_found/views/sign_up.page.dart';
import 'package:lost_and_found/views/use_term_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achados e Perdidos',
      theme: new ThemeData(
        primarySwatch: Colors.amber
      ),
      debugShowCheckedModeBanner: false,
      home: RootPage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        RootPage.routeName: (context) => new RootPage(),
        SignInPage.routeName: (context) => new SignInPage(),
        SignUpPage.routeName: (context) => new SignUpPage(),
        HomePage.routeName: (context) => new HomePage(),
        AboutPage.routeName: (context) => new AboutPage(),
        ProfilePage.routeName: (context) => new ProfilePage(),
        UseTermPage.routeName: (context) => new UseTermPage(),
        FoundPage.routeName: (context) => new FoundPage(),
        LostObjectDetailPage.routeName: (context) => new LostObjectDetailPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt'), 
        const Locale('en'), 
        const Locale('es'), 
      ],
    );
  }
}
