import 'dart:convert';
import 'package:flutter_uploader/flutter_uploader.dart';

final uploader = FlutterUploader();

// Trying to figure out how to send a cat to file.io
// https://pub.dev/documentation/flutter_uploader/latest/

String uploadCat({filename: '/storage/emulated/0/Download/catpeek.png'}) {

  UploadTaskResponse result;

  String link;
    uploader.enqueue(
    url: "https://file.io",
    files: [FileItem(filename: filename, savedDir: '', fieldname:"file")],
    method: UploadMethod.POST,
  );

  uploader.result.listen((result) {
    Map<String, dynamic> _result = jsonDecode(result.response);
    link = _result['link'];

  }, onError: (ex, stacktrace) {
    print("$ex, $stacktrace");
    link = 'Error';
  });

  return link;
}
