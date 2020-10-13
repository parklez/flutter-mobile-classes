import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/image_helper.dart';

class ImageArea extends StatefulWidget {
  final String emptyText;
  final String userId;
  final bool enableCamera;
  final bool enableGallery;
  final Function onCompleted;
  final String url;

  ImageArea(
      {this.userId = '',
      this.url,
      this.emptyText = 'Sem imagem',
      this.enableCamera = true,
      this.enableGallery = true,
      this.onCompleted});

  @override
  _ImageAreaState createState() => _ImageAreaState();
}

class _ImageAreaState extends State<ImageArea> {
  File _localImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildImageContainer(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildImageContainer() {
    return Container(
      padding: EdgeInsets.all(4.0),
      height: 200.0,
      color: Theme.of(context).primaryColor,
      child: _loadImage(),
    );
  }

  Widget _loadImage() {
    if (_localImage != null) {
      return Center(
        child: Image.file(_localImage, fit: BoxFit.fill,),
      );
    }

    if (widget.url != null) {
      return Center(
        child: CachedNetworkImage(
          imageUrl: widget.url,
          placeholder: (context, url) => CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      );
    }

    return Center(
      child: Text(widget.emptyText),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      height: 200.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          widget.enableGallery
              ? IconButton(
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: _getImageFromGallery,
                )
              : SizedBox(),
          widget.enableCamera
              ? IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: _getImageFromCamera,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Future _getImageFromCamera() async {
    ImageHelper.getImageFromCamera().then(_setImage);
  }

  Future _getImageFromGallery() async {
    ImageHelper.getImageFromGallery().then(_setImage);
  }

  Future<String> _sendImageToFirebase() async {
    final String path =
        widget.userId + DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference storageReference =
        FirebaseStorage().ref().child(path);
    final StorageUploadTask uploadTask = storageReference.putFile(_localImage);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.snapshot.bytesTransferred}');
      print('EVENT ${event.snapshot.totalByteCount}');
      print('EVENT ${event.type}');
    });

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    streamSubscription.cancel();

    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  void _setImage(File image) {
    setState(() {
      if (image == null) {
        return;
      }

      _localImage = image;

      _sendImageToFirebase().then((url) {
        if (widget.onCompleted != null) widget.onCompleted(url);
      });
    });
  }
}
