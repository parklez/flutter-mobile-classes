import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String rant = """
  Kleber, if you're reading this, as much as I'd like to have all the time in the world to make this nicer looking with features and stuff,
  truth is, I did all assingments/apps by myself, ALONE! (same for all other classes!) and it's not because I can't talk to people, rather:
  it's nearly impossible for students to get the knowledge they need to build apps from the ground up, let's face it.
  I'm lucky(?) to have studied programming with passion earlier on before joining this course but it's still an ocean of new things to learn
  and handle in this life... all by myself. So yeah, boohoo, that's what I managed to do without loosing my mind (and I nearly did)
  """;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          Text('Hey there, this is my "honest work" app made as my final assignment from my android app making class. Kleber, read the code for a rant!'),
          Text(''),
          Text('Technologies/Plugins used listed below:'),
          Divider(),
          Text('- file_picker by miguelruivo.com'),
          Text('- flutter_uploader by onikiri2007@gmail.com'),
          Text('- liquid_progress_indicator by jordandavies1990@live.co.uk'),
          Text('- share by flutter.dev'),
          Text('- flushbar by andrehaueisen@gmail.com'),
          Text('- clipboard_manager by anuranbarman@gmail.com'),
          Text('- dynamic_theme by https://github.com/Norbert515/dynamic_theme'),

        ],
      );
  }
}