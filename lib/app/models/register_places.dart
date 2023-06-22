// To parse this JSON data, do
//
//     final registerPlaces = registerPlacesFromJson(jsonString);

import 'dart:convert';

RegisterPlaces registerPlacesFromJson(String str) =>
    RegisterPlaces.fromJson(json.decode(str));

String registerPlacesToJson(RegisterPlaces data) => json.encode(data.toJson());

class RegisterPlaces {
  RegisterPlaces({
    this.success,
    this.data,
    this.message,
  });

  String success;
  List<Places> data;
  String message;

  factory RegisterPlaces.fromJson(Map<String, dynamic> json) => RegisterPlaces(
        success: json["success"],
        data: List<Places>.from(json["data"].map((x) => Places.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Places {
  Places({
    this.cityId,
    this.cityName,
  });

  int cityId;
  String cityName;

  factory Places.fromJson(Map<String, dynamic> json) => Places(
        cityId: json["cityID"],
        cityName: json["cityName"],
      );

  Map<String, dynamic> toJson() => {
        "cityID": cityId,
        "cityName": cityName,
      };
}
