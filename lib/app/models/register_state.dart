// To parse this JSON data, do
//
//     final registerState = registerStateFromJson(jsonString);

import 'dart:convert';

RegisterState registerStateFromJson(String str) =>
    RegisterState.fromJson(json.decode(str));

String registerStateToJson(RegisterState data) => json.encode(data.toJson());

class RegisterState {
  RegisterState({
    this.success,
    this.data,
    this.message,
  });

  String success;
  List<States> data;
  String message;

  factory RegisterState.fromJson(Map<String, dynamic> json) => RegisterState(
        success: json["success"],
        data: List<States>.from(json["data"].map((x) => States.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class States {
  States({
    this.stateId,
    this.stateName,
  });

  int stateId;
  String stateName;

  factory States.fromJson(Map<String, dynamic> json) => States(
        stateId: json["stateID"],
        stateName: json["stateName"],
      );

  Map<String, dynamic> toJson() => {
        "stateID": stateId,
        "stateName": stateName,
      };
}
