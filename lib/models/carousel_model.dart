import 'dart:convert';

CarouselModel carouselModelFromJson(String str) =>
    CarouselModel.fromJson(json.decode(str));

String carouselModelToJson(CarouselModel data) => json.encode(data.toJson());

class CarouselModel {
  String image;

  CarouselModel({
    required this.image,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) => CarouselModel(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
