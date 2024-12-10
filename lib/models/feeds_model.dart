import 'dart:convert';

FeedsModel feedsModelFromJson(String str) =>
    FeedsModel.fromJson(json.decode(str));

String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

class FeedsModel {
  String? text;
  String? image;

  FeedsModel({
    this.text,
    this.image,
  });

  factory FeedsModel.fromJson(Map<String, dynamic> json) => FeedsModel(
        text: json["text"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "image": image,
      };
}
