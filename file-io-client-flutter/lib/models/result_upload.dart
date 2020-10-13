import 'dart:convert';

class ResultUpload{
  String success;
  String key;
  String link;
  String expiry;

  ResultUpload({
    this.success,
    this.key,
    this.link,
    this.expiry
  });

  factory ResultUpload.fromJson(String str) => ResultUpload.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultUpload.fromMap(Map<String, dynamic> json) => ResultUpload(
    success: json['success'] == null ? null : json['success'],
    key: json['key'] == null ? null : json['key'],
    link: json['link'] == null ? null : json['link'],
    expiry: json['expiry'] == null ? null : json['expiry'],
  );

  Map<String, dynamic> toMap() => {
    'sucess': success == null ? null : success,
    'key': key == null ? null : key,
    'link': link == null ? null : link,
    'expiry': expiry == null ? null : expiry,
  };
}