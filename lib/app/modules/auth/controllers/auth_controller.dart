import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/provider_registration.dart';
import '../../../models/register_places.dart';
import '../../../models/register_state.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/select_dialog.dart';

class AuthController extends GetxController {
  Rx<User> currentUser = Get.find<AuthService>().user;
  final Rx<RegProvider> regProvider = RegProvider().obs;
  final house = ''.obs;
  final pin = ''.obs;
  final area = ''.obs;
  final servicesCategory = <CatService>[].obs;
  final servicess = <CatService>[].obs;
  final states = <States>[].obs;
  final places = <Places>[].obs;
  final typelist = <EProviderType>[].obs;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  GlobalKey<FormState> providerFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  final type = ''.obs;
  final phoneLogin = false.obs;
  final frombook = false.obs;
  final isregister = false.obs;
  final smsSent = ''.obs;
  UserRepository _userRepository;
  final scrollIndex = 0.obs;
  AuthController() {
    _userRepository = UserRepository();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    if (Get.arguments != null) {
      var arg = Get.arguments as Map<String, dynamic>;
      if (arg.containsKey("isregister")) {
        if (arg["isregister"] as bool) {
          scrollIndex.value = 0;
        } else {
          scrollIndex.value = 1;
        }

        frombook.value = arg["isbook"];
      }
    }
    super.onInit();
  }

  List<SelectDialogItem<CatService>> getCategories() {
    print("servicesCategory is $servicesCategory");
    return servicesCategory.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<CatService>> getService() {
    print("servicesCategory is ${servicess}");
    return servicess.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<Places>> getCity(String sid) {
    print("servicesCategory is ${servicess}");
    getPlaces(sid.toString());
    return places.map((element) {
      return SelectDialogItem(element, element.cityName);
    }).toList();
  }

  // List<SelectDialogItem<States>> getStatelist() {
  //   print("servicesCategory is ${servicess}");
  //   getStateslist();
  //   return states.map((element) {
  //     return SelectDialogItem(element, element.stateName);
  //   }).toList();
  // }

  List<States> getDropdownForStates() {
    return states.map((element) {
      return element;
    }).toList();
  }

  List<Places> getDropdownForPlaces() {
    return places.map((element) {
      return element;
    }).toList();
  }

  List<SelectDialogItem<EProviderType>> getProType() {
    print("servicesCategory is ${servicess}");
    return typelist.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  void setType(String typecode) {
    type.value = typecode;
  }

  Future getServiceCategories() async {
    List<CatService> catservice = await _userRepository.getServiceCategories();
    servicesCategory.assignAll(catservice);

    print("servicesCategory is $servicesCategory");
  }

  Future getServices(String id) async {
    servicess.assignAll(await _userRepository.getServices(id));

    print("services is $servicess");
  }

  Future getProvidertype() async {
    typelist.assignAll(await _userRepository.getProvidertype());

    print("services is $typelist");
  }

  Future getStateslist() async {
    List<States> stateslist = await _userRepository.getStateslist();
    states.assignAll(stateslist);
  }

  Future getPlaces(String id) async {
    List<Places> placeslist = await _userRepository.getCities(id);
    places.assignAll(placeslist);
  }

  void setPhonelogin() {
    phoneLogin.value = !phoneLogin.value;
  }

  void setScrollIndex(int i) {
    scrollIndex.value = i;
  }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        if (!phoneLogin.value) {
          await Get.find<FireBaseMessagingService>().setDeviceToken();
          currentUser.value = await _userRepository.login(currentUser.value);
          loading.value = false;
          await Get.toNamed(Routes.ROOT, arguments: 0);
        } else {
          await _userRepository.sendCodeToPhone().then((value) async {
            loading.value = false;
            await Get.toNamed(Routes.PHONE_VERIFICATION);
          });
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(
            message: "These credentials do not match our records."));
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      try {
        if (Get.find<SettingsService>().setting.value.enableOtp) {
          // await _userRepository.sendCodeToPhone();
          loading.value = false;
        } else {
          //currentUser.value = await _userRepository.register(currentUser.value);
          dynamic response = await _userRepository.sendCodeToPhone();
          // await Get.find<FireBaseMessagingService>().setDeviceToken();
          //currentUser.value = await _userRepository.register(currentUser.value);
          loading.value = false;

          await Get.toNamed(Routes.PHONE_VERIFICATION,
              arguments: [response, "register"]);
          // await _userRepository
          //     .signUpWithEmailAndPassword(
          //         currentUser.value.email, currentUser.value.apiToken)
          //     .then((value) async {
          //   // await Get.toNamed(Routes.PROVIDER_REGISTRATION);
          //   await Get.toNamed(Routes.PHONE_VERIFICATION);
          // });

          // await getServiceCategories();
          ;
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  registerprovider() async {
    RegProvider reg = new RegProvider(
        aadhaarNo: currentUser.value.aadharNo ?? regProvider.value.aadhaarNo,
        education: regProvider.value.education,
        experience: regProvider.value.experience,
        addressProof: regProvider.value.addressProof,
        description: regProvider.value.description,
        availabilityRange: regProvider.value.availabilityRange,
        address:
            currentUser.value.permanentAddress ?? regProvider.value.address,
        workAddress: regProvider.value.workAddress,
        yearsOfExperience: regProvider.value.yearsOfExperience,
        dob: regProvider.value.dob,
        gender: regProvider.value.gender,
        services: regProvider.value.services,
        idProof: regProvider.value.idProof,
        certification: regProvider.value.certification,
        taxes: regProvider.value.taxes,
        pincode: currentUser.value.pincode ?? pin.value,
        files: regProvider.value.files,
        city: currentUser.value.city ?? regProvider.value.city,
        state: currentUser.value.state ?? regProvider.value.state,
        providertype:
            currentUser.value.providerTypeId ?? regProvider.value.providertype);
    await _userRepository.registerProvider(reg);
    Get.showSnackbar(Ui.SuccessSnackBar(message: "KYC Updated successfully!"));
    await Get.toNamed(Routes.ROOT, arguments: 0);
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;

      await Get.find<FireBaseMessagingService>().setDeviceToken();
      // currentUser.value = await _userRepository.register(currentUser.value);
      if (type.value == "login") {
        currentUser.value = await _userRepository.verifyPhone(smsSent.value);

        await Get.offAllNamed(Routes.ROOT, arguments: 0);
      } else {
        await _userRepository.verifyPhone(smsSent.value);
        frombook.value = false;
        await Get.offAllNamed(Routes.ROOT, arguments: {'isbook': true});
      }
      // await _userRepository.signUpWithEmailAndPassword(
      //     currentUser.value.email, currentUser.value.apiToken);
      loading.value = false;

      // await Get.offAllNamed(Routes.ROOT);
    } catch (e) {
      loading.value = false;
      Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> verifyOTP(String mobileno) async {
    try {
      loading.value = true;
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value =
          await _userRepository.verifyOTP(smsSent.value, mobileno);
      if (currentUser.value != null) {
        await Get.toNamed(Routes.PROFILE, arguments: "reset");
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
