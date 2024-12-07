import 'dart:convert';

class BaseItemModel<T> {
  bool success;
  String? message;
  String? error;
  T? data;

  BaseItemModel({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory BaseItemModel.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return BaseItemModel(
      success: json['success'] ?? false,
      data: json.containsKey('data') ? fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = toJson(this.data as T);
    }
    if (message != null) {
      data['message'] = message;
    }
    if (error != null) {
      data['error'] = error;
    }

    return data;
  }

  factory BaseItemModel.fromRawJson(String str, T Function(dynamic) fromJson) =>
      BaseItemModel.fromJson(json.decode(str), fromJson);

  String toRawJson(Map<String, dynamic> Function(T) toJson) {
    if (this.data != null) {
      json.encode(toJson(this.data as T));
    }
    return "Sorry we couldn't find data";
  }
}
