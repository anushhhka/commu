import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

FeedsModel feedsModelFromJson(String str) =>
    FeedsModel.fromJson(json.decode(str));

String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

class FeedsModel {
  String? text;
  String? image;
  Timestamp? createdAt;

  FeedsModel({
    this.text,
    this.image,
    this.createdAt,
  });

  factory FeedsModel.fromJson(Map<String, dynamic> json) => FeedsModel(
        text: json["text"],
        image: json["image"],
        createdAt: json["createdAt"] == null
            ? null
            : Timestamp.fromDate(json["createdAt"].toDate()),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "image": image,
        "createdAt": createdAt,
      };
}
