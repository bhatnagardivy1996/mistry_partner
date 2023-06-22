import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/countries.dart';
import '../services/settings_service.dart';
import '../../common/uuid.dart';
import 'package:get/get.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'role_model.dart';

class User extends Model {
  String name;
  String email;
  String password;
  Media avatar;
  List<Media> media;
  String apiToken;
  String deviceToken;
  String phoneNumber;
  int providerid;
  bool verifiedPhone;
  String verificationId;
  String address;
  String permanentAddress;
  String bio;
  List<Role> roles;
  String aadharNo;
  String state;
  String city;
  String pincode;
  String providerTypeId;
  String providerTypeName;
  bool auth;

  User(
      {this.name,
      this.email,
      this.password,
      this.apiToken,
      this.deviceToken,
      this.phoneNumber,
      this.providerid,
      this.verifiedPhone,
      this.verificationId,
      this.address,
      this.permanentAddress,
      this.bio,
      this.avatar,
      this.media,
      this.roles,
      this.aadharNo,
      this.state,
      this.city,
      this.providerTypeId,
      this.providerTypeName,
      this.pincode});

  User.fromJson(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    email = stringFromJson(json, 'email');
    apiToken = stringFromJson(json, 'api_token');
    deviceToken = stringFromJson(json, 'device_token');
    phoneNumber = stringFromJson(json, 'phone_number');
    providerid = intFromJson(json, "provider_id");
    verifiedPhone = boolFromJson(json, 'phone_verified_at');
    if (json['avatar'] != null && json['avatar'] != "") {
      avatar = avatarFromJson(json, 'avatar');
    }
    // avatar = mediaFromJson(json, 'avatar');
    media = listFromJson(json, 'media', (v) => Media.fromJson(v));
    auth = boolFromJson(json, 'auth');
    roles = listFromJson(json, 'roles', (v) => Role.fromJson(v));
    address = stringFromJson(json, 'user_address');
    permanentAddress = stringFromJson(json, 'permanent_address');
    bio = stringFromJson(json, 'user_bio');
    aadharNo = stringFromJson(json, 'aadhaar_no', defaultValue: "");
    state = stringFromJson(json, 'state', defaultValue: "");
    city = stringFromJson(json, 'city', defaultValue: "");
    pincode = stringFromJson(json, 'pincode');
    providerTypeId = stringFromJson(json, 'e_provider_type_id');
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['provider_id'] = this.providerid;
    if (password != null && password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this.apiToken;
    if (deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone_number"] = phoneNumber;
    if (verifiedPhone != null && verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["address"] = this.address;
    data["permanent_address"] = this.permanentAddress;
    data["bio"] = bio;
    if (this.avatar != null && Uuid.isUuid(avatar.id)) {
      data['avatar'] = this.avatar.id;
    }
    data['media'] = this.media;
    data['auth'] = this.auth;
    if (roles != null) {
      data['roles'] = this.roles.map((e) => e.toJson()).toList();
    }
    data["aadhaar_no"] = this.aadharNo;
    data["pincode"] = this.pincode;
    data["state"] = this.state;
    data["city"] = this.city;
    data["e_provider_type_id"] = this.providerTypeId;
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = avatar?.thumb ?? "";
    map["device_token"] = deviceToken;
    return map;
  }

  PhoneNumber getPhoneNumber() {
    if (this.phoneNumber != null && this.phoneNumber.length > 4) {
      this.phoneNumber = this.phoneNumber.replaceAll(' ', '');
      String dialCode1 = this.phoneNumber.substring(1, 2);
      String dialCode2 = this.phoneNumber.substring(1, 3);
      String dialCode3 = this.phoneNumber.substring(1, 4);
      for (int i = 0; i < countries.length; i++) {
        if (countries[i].dialCode == dialCode1) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode1,
              number: this.phoneNumber.substring(2));
        } else if (countries[i].dialCode == dialCode2) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode2,
              number: this.phoneNumber.substring(3));
        } else if (countries[i].dialCode == dialCode3) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode3,
              number: this.phoneNumber.substring(4));
        }
      }
    }
    return new PhoneNumber(
        countryISOCode:
            Get.find<SettingsService>().setting.value.defaultCountryCode,
        countryCode: '1',
        number: '');
  }

  bool get isAdmin =>
      (this.roles?.where((element) => element.name == 'admin')?.length ?? 0) >
      0;

  bool get isProvider =>
      (this
              .roles
              ?.where((element) =>
                  element.name == 'provider' || element.name == 'admin')
              ?.length ??
          0) >
      0;

  bool get isCustomer =>
      (this.roles?.where((element) => element.isdDefault)?.length ?? 0) > 0;

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is User &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      email == other.email &&
      password == other.password &&
      avatar == other.avatar &&
      apiToken == other.apiToken &&
      deviceToken == other.deviceToken &&
      phoneNumber == other.phoneNumber &&
      verifiedPhone == other.verifiedPhone &&
      verificationId == other.verificationId &&
      address == other.address &&
      bio == other.bio &&
      roles == other.roles &&
      auth == other.auth;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      roles.hashCode ^
      auth.hashCode;
}
