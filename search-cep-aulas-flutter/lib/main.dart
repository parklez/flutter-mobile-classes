import 'package:flutter/material.dart';
import 'package:search_cep/views/home_page.dart';
import 'package:search_cep/themes/lightblue.dart';
import 'package:search_cep/themes/purpledark.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class MyColorfulApp extends StatelessWidget {
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
              theme: theme,
              darkTheme: myPurpleDarkTheme,
              home: HomePage(),
            );
          }
        );
      }
    }

void main() {
  runApp(
    MyColorfulApp()
    );
}
