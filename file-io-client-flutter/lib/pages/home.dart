import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_io_client/pages/about.dart';
import 'package:file_io_client/pages/upload.dart';
import 'package:file_io_client/themes/lightblue.dart';
import 'package:file_io_client/themes/purpledark.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // https://www.youtube.com/watch?v=n_FRmFm9Tyw
  int _selectedPage = 0;

  List _pageOptions = [
    UploadPage(),
    Text('This is where all links would be saved if we had a database n stuff'),
    AboutPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('File.io Cloud Client ☁', style: TextStyle(),),
      actions: <Widget>[
        IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    onPressed: (){
                      if (Theme.of(context).brightness == Brightness.light){
                        DynamicTheme.of(context).setThemeData(myPurpleDarkTheme);
                      }
                      else{
                        DynamicTheme.of(context).setThemeData(myLightBlueTheme);                        
                      }
                    },
                  )
        ],
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index){
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            title: Text('Upload')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('About')
          ),
        ],
      ),
    );
  }
}