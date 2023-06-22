// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class PhoneVerificationView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;
  final Rx<User> currentUser = Get.find<AuthService>().user;
  String otpCode = "";
  @override
  Widget build(BuildContext context) {
    otpCode = Get.arguments != null ? Get.arguments[0].first.toString() : "";
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          body: ListView(
        primary: true,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: 180,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.background,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  // // boxShadow: [
                  // //   BoxShadow(
                  // //       color: Get.theme.focusColor.withOpacity(0.2),
                  // //       blurRadius: 10,
                  // //       offset: Offset(0, 5)
                  // //       ),
                  // ],
                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        _settings.providerAppName,
                        style: Get.textTheme.titleLarge.merge(
                            TextStyle(color: Colors.black, fontSize: 24)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.loading.isTrue) {
              return CircularLoadingWidget(height: 300);
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter OTP Sent to your mobile number".tr,
                    style: Get.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 20, vertical: 20),
                  TextFieldWidget(
                    labelText: "OTP Code".tr,
                    hintText: "- - - -".tr,
                    style: Get.textTheme.headlineMedium
                        .merge(TextStyle(letterSpacing: 8)),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (input) => controller.smsSent.value = input,
                    // iconData: Icons.add_to_home_screen_outlined,
                  ),
                  BlockButtonWidget(
                    onPressed: () async {
                      if (Get.arguments[1].toString() == "register") {
                        if (otpCode == controller.smsSent.value) {
                          try {
                            currentUser.value = await UserRepository()
                                .register(currentUser.value);
                          } catch (e) {
                            currentUser.update((val) {
                              val.name = "";
                              val.password = "";
                              val.phoneNumber = "";
                            });
                            Get.showSnackbar(Ui.ErrorSnackBar(
                                title: "Error:",
                                message:
                                    "The phone number has already been taken!"));
                          }
                          await Get.toNamed(Routes.ROOT, arguments: 0);
                        } else {
                          Get.showSnackbar(Ui.ErrorSnackBar(
                              message:
                                  "Incorrect OTP!\nPlease click on Resend OTP to generate new OTP"
                                      .tr));
                        }
                      } else if (Get.arguments[1].toString() == "forgot") {
                        if (otpCode == controller.smsSent.value) {
                          await Get.toNamed(Routes.ROOT, arguments: 0);
                        } else {
                          Get.showSnackbar(Ui.ErrorSnackBar(
                              message:
                                  "Incorrect OTP!\nPlease click on Resend OTP to generate new OTP"
                                      .tr));
                        }
                      }
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Next".tr,
                      style: Get.textTheme.titleLarge
                          .merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingSymmetric(vertical: 30, horizontal: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          dynamic resp =
                              await UserRepository().sendCodeToPhone();
                          otpCode = resp.first.toString();
                          Get.showSnackbar(Ui.SuccessSnackBar(
                              message: "OTP Re-sent Successfully".tr));
                        },
                        child: Text("Resend OTP".tr),
                      ),
                    ],
                  )
                ],
              );
            }
          })
        ],
      )),
    );
  }
}
