import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LostObject {
  final String title;
  final String description;
  final String pictureUrl;
  final String local;
  final String date;
  final String finderUserId;

  LostObject({
    this.title,
    this.description,
    this.pictureUrl,
    this.local,
    this.date,
    this.finderUserId,
  });

  String getInitials() {
    if (title.isNotEmpty)
      return title.toUpperCase()[0];
    else
      return '?';
  }

  factory LostObject.fromDocument(DocumentSnapshot document) {
    return LostObject.fromMap(document.data);
  }

  factory LostObject.fromJson(String str) =>
      LostObject.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LostObject.fromMap(Map<String, dynamic> json) => LostObject(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        pictureUrl: json["pictureUrl"] == null ? null : json["pictureUrl"],
        local: json["local"] == null ? null : json["local"],
        date: json["date"] == null ? null : json["date"],
        finderUserId:
            json["finderUserId"] == null ? null : json["finderUserId"],
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "pictureUrl": pictureUrl == null ? null : pictureUrl,
        "local": local == null ? null : local,
        "date": date == null ? null : date,
        "finderUserId": finderUserId == null ? null : finderUserId,
      };
}
