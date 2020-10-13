
import 'dart:convert';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:file_io_client/models/result_upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  double _expirationTime = 14;
  String _filePath = '';
  ResultUpload result;
  double _progress = 0.0;
  var _resultField = TextEditingController();

  
  final uploader = FlutterUploader();
  
  void _uploadFile() {
    String filename = _filePath;

    if (_filePath == ''){
      return;
    }

    setState(() {
      _progress = 0.0;
    });

    String link;
      uploader.enqueue(
      url: "https://file.io?expires=" + _expirationTime.toStringAsFixed(0),
      files: [FileItem(filename: filename, savedDir: '', fieldname:"file")],
      method: UploadMethod.POST,
    );

    uploader.progress.listen((progress) {
      setState(() {
         _progress = progress.progress.toDouble();
      });
    });

    uploader.result.listen((result) {

      Map<String, dynamic> _result = jsonDecode(result.response);
      link = _result['link'];
      setState(() {
        _resultField.text = link;
      });

    }, onError: (ex, stacktrace) {
      print("$ex, $stacktrace");
      setState(() {
        _resultField.text = 'Something went wrong!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Divider(),
          Text('1. Choose a file', style: TextStyle(fontSize: 25.0),),
          Divider(),
          RaisedButton(
              onPressed: () async {
                _filePath = await FilePicker.getFilePath(type: FileType.ANY);
                // This is a good meme I decided to try for the giggles and turns out it WORKS!
                setState(() {
                  _filePath = _filePath;
                  _progress = 0.0;
                  _resultField.text = '';
                });
                },
                child: Text('Browse Files...'),
              ),
          Text('$_filePath'),
          Divider(),
          Text('2. Set expiry (days)', style: TextStyle(fontSize: 25.0),),
          Slider(
            value: _expirationTime,
            max: 14,
            min: 1,
            label: '${_expirationTime.toStringAsFixed(0)} days',
            divisions: 14,
            onChanged: (newValue){
              setState(() {
                _expirationTime = newValue;
              });
            },
          ),
          Divider(),
          RaisedButton(onPressed: (){
            if (_filePath == ''){
                Flushbar(
                  message:  "You must choose a file first! :)",
                  duration:  Duration(seconds: 3),              
              )..show(context);
            }
            else{
             _uploadFile();
            }
          },
          child: Text('Upload')
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Flexible(child: TextFormField(controller: _resultField, decoration: InputDecoration(labelText: 'Link'),)),
                IconButton(icon: Icon(Icons.content_paste),
                          onPressed: (){
                            ClipboardManager.copyToClipBoard("${_resultField.text}").then((result) {
                              final snackBar = SnackBar(
                                content: Text('Link copied to Clipboard!'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {},
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            });
                          },
                          )
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
            child: LiquidLinearProgressIndicator(
              value: _progress/100, // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
              backgroundColor: Theme.of(context).backgroundColor, // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.blue,
              borderWidth: 5.0,
              borderRadius: 12.0,
              direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
              center: Text("Upload progress (${_progress.toStringAsFixed(0)}%)"),
            )
          )
        ],
      ),
    );
  }
}