import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  final String initials;
  final String pictureUrl;
  final double radius;

  CircleNetworkImage({this.initials, this.pictureUrl, this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl.isNotEmpty)
      return _drawImage();
    else
      return _drawText();
  }

  Widget _drawText() {
    return CircleAvatar(
      maxRadius: 20.0,
      child: Text(initials ?? '?'),
    );
  }

  Widget _drawImage() {
    return ClipOval(
      child: Container(
        color: Colors.red,
        width: 40.0,
        height: 40.0,
        child: CachedNetworkImage(
          imageUrl: pictureUrl,
          placeholder: (context, url) => CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
