import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lost_and_found/services/auth.dart';
import 'package:lost_and_found/views/root_page.dart';

class Common {
  static Future setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<bool> showQuitDialog(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sair"),
          content: Text("Você realmente deseja sair do aplicativo?"),
          actions: <Widget>[
            FlatButton(
              child: Text("SIM"),
              onPressed: () {
                Auth.signOut();
                Navigator.pushReplacementNamed(context, RootPage.routeName);
              },
            ),
            FlatButton(
              child: Text("NÃO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return Future.value(false);
  }

  static Widget progressContainer() {
    return Center(child: CircularProgressIndicator());
  }

  static Widget errorContainer({String error}) {
    return Center(child: Text(error));
  }

  static Widget emptyContainer({String message}) {
    return Center(child: Text(message));
  }
}
