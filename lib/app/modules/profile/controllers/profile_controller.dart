import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/provider_registration.dart';
import '../../../models/register_places.dart';
import '../../../models/register_state.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final hidePassword2 = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final states = <States>[].obs;
  final places = <Places>[].obs;
  final Rx<RegProvider> regProvider = RegProvider().obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;
  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    avatar.value = new Media(thumb: user.value.avatar?.thumb ?? "");
    print("hitesh");
    print(new Media(thumb: user.value.avatar?.thumb ?? ""));
    super.onInit();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of faqs refreshed successfully".tr));
    }
  }

  List<States> getDropdownForStates() {
    return states.map((element) {
      return element;
    }).toList();
  }

  Future getStateslist() async {
    List<States> stateslist = await _userRepository.getStateslist();
    states.assignAll(stateslist);
  }

  Future getPlaces(String id) async {
    List<Places> placeslist = await _userRepository.getCities(id);
    places.assignAll(placeslist);
  }

  List<Places> getDropdownForPlaces() {
    return places.map((element) {
      return element;
    }).toList();
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      try {
        // profileForm.currentState.save();
        user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value
            ? newPassword.value
            : null;
        user.value.avatar = avatar.value;
        if (Get.find<SettingsService>().setting.value.enableOtp) {
          await _userRepository.sendCodeToPhone();
          Get.bottomSheet(
            PhoneVerificationBottomSheetWidget(),
            isScrollControlled: false,
          );
        } else {
          RegProvider reg = new RegProvider(
              state: user.value.state,
              city: user.value.city,
              pincode: user.value.pincode);
          user.value = await _userRepository.update(user.value);
          await _userRepository.registerProvider(reg);
          print(user.value);
          user.value.avatar = user.value.media
              .firstWhere((element) => element.type == 'avatar');
          Get.find<AuthService>().user.value = user.value;
          Get.back();

          Get.showSnackbar(
              Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar?.thumb ?? "");
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
