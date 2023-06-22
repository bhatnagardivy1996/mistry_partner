// To parse this JSON data, do
//
//     final regProvider = regProviderFromJson(jsonString);

import 'dart:convert';

import 'media_model.dart';
import 'parents/model.dart';

RegProvider regProviderFromJson(String str) =>
    RegProvider.fromJson(json.decode(str));

String regProviderToJson(RegProvider data) => json.encode(data.toJson());

class RegProvider extends Model {
  RegProvider({
    this.providerId,
    this.description,
    this.files,
    this.taxes,
    this.availabilityRange,
    this.experience,
    this.dob,
    this.aadhaarNo,
    this.gender,
    this.address,
    this.education,
    this.certification,
    this.services,
    this.category,
    this.workAddress,
    this.pincode,
    this.yearsOfExperience,
    this.idProof,
    this.addressProof,
    this.providertype,
    this.state,
    this.city,
  });

  String providerId;
  String description;
  String files;
  String taxes;
  String availabilityRange;
  String experience;
  String dob;
  String aadhaarNo;
  String gender;
  String address;
  String education;
  String certification;
  String services;
  String workAddress;
  String category;
  String pincode;
  String city;
  String state;
  String providertype;
  String yearsOfExperience;
  List<Media> idProof;
  List<Media> addressProof;

  factory RegProvider.fromJson(Map<String, dynamic> json) => RegProvider(
        providerId: json["provider_id"],
        description: json["description"],
        files: json["files"],
        taxes: json["taxes"],
        availabilityRange: json["availability_range"],
        experience: json["experience"],
        dob: json["dob"],
        aadhaarNo: json["aadhaar_no"],
        gender: json["gender"],
        address: json["permanent_address"],
        education: json["education"],
        certification: json["certification"],
        services: json["services"],
        workAddress: json["work_address"],
        pincode: json["pincode"],
        category: json["category"],
        yearsOfExperience: json["years_of_experience"],
        idProof: json["id_proof"],
        addressProof: json["address_proof"],
        providertype: json["provider_type"],
        state: json["state"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "description": description,
        "files": files,
        "taxes": taxes,
        "availability_range": availabilityRange,
        "experience": experience,
        "dob": dob,
        "aadhaar_no": aadhaarNo,
        "gender": gender,
        "permanent_address": address,
        "education": education,
        "certification": certification,
        "services": services,
        "work_address": workAddress,
        "category": category,
        "pincode": pincode,
        "years_of_experience": yearsOfExperience,
        "id_proof": idProof,
        "address_proof": addressProof,
        "provider_type": providertype,
        "city": city,
        "state": state,
      };
}

CatService catServiceFromJson(String str) =>
    CatService.fromJson(json.decode(str));

String catServiceToJson(CatService data) => json.encode(data.toJson());

class CatService {
  CatService({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory CatService.fromJson(Map<String, dynamic> json) => CatService(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Name {
  Name({
    this.en,
  });

  String en;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}
