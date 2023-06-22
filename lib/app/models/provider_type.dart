// To parse this JSON data, do
//
//     final providerType = providerTypeFromJson(jsonString);

import 'dart:convert';

ProviderType providerTypeFromJson(String str) =>
    ProviderType.fromJson(json.decode(str));

String providerTypeToJson(ProviderType data) => json.encode(data.toJson());

class ProviderType {
  ProviderType({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<ProType> data;
  String message;

  factory ProviderType.fromJson(Map<String, dynamic> json) => ProviderType(
        success: json["success"],
        data: List<ProType>.from(json["data"].map((x) => ProType.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ProType {
  ProType({
    this.id,
    this.name,
    this.commission,
    this.disabled,
    this.customFields,
  });

  int id;
  String name;
  int commission;
  bool disabled;
  List<dynamic> customFields;

  factory ProType.fromJson(Map<String, dynamic> json) => ProType(
        id: json["id"],
        name: json["name"],
        commission: json["commission"],
        disabled: json["disabled"],
        customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "commission": commission,
        "disabled": disabled,
        "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
      };
}
