import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_io_client/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:file_io_client/themes/lightblue.dart';
import 'package:file_io_client/themes/purpledark.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
          defaultBrightness: Brightness.light,
          // The line below will receive its default ThemeData,
          // in this case I'll set as my custom blue theme
          data: (brightness) => myLightBlueTheme,
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomePage(),
              theme: theme,
              darkTheme: myPurpleDarkTheme,
        );
      }
    );
  }
}