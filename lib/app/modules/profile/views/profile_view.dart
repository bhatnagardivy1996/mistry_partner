import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';
import '../../../models/register_places.dart';
import '../../../models/register_state.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;
  States selectedState;
  Places selectedPlace;
  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  init() async {
    await controller.getStateslist();
  }

  @override
  Widget build(BuildContext context) {
    controller.profileForm = new GlobalKey<FormState>();
    init();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Profile".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: Get.arguments != "reset"
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Get.theme.hintColor),
                        onPressed: () => Get.back(),
                      )
                    : SizedBox.shrink(),
                elevation: 0,
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    controller.saveProfileForm();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              ),
              SizedBox(width: 10),
              // MaterialButton(
              //   onPressed: () {
              //     controller.resetProfileForm();
              //   },
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10)),
              //   color: Get.theme.hintColor.withOpacity(0.1),
              //   child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              //   elevation: 0,
              //   highlightElevation: 0,
              //   hoverElevation: 0,
              //   focusElevation: 0,
              // ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              Text("Profile details".tr, style: Get.textTheme.headline5)
                  .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Change the following details and save them".tr,
                      style: Get.textTheme.caption)
                  .paddingSymmetric(horizontal: 22, vertical: 5),
              ImageFieldWidget(
                label: "Image".tr,
                field: 'avatar',
                tag: controller.profileForm.hashCode.toString(),
                initialImage: controller.avatar.value,
                uploadCompleted: (uuid) {
                  controller.avatar.value = new Media(id: uuid);
                },
                reset: (uuid) {
                  controller.avatar.value = new Media(
                      thumb: controller.user.value.avatar?.thumb ?? "");
                },
              ),
              TextFieldWidget(
                onChanged: (input) => controller.user.value.name = input,
                validator: (input) => input.length < 3
                    ? "Should be more than 3 letters".tr
                    : null,
                initialValue: controller.user.value.name,
                hintText: "John Doe".tr,
                labelText: "Full Name".tr,
                iconData: Icons.person_outline,
              ),
              // TextFieldWidget(
              //   onSaved: (input) => controller.user.value.email = input,
              //   validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
              //   initialValue: controller.user.value.email,
              //   hintText: "johndoe@gmail.com",
              //   labelText: "Email".tr,
              //   iconData: Icons.alternate_email,
              // ),
              PhoneFieldWidget(
                labelText: "Phone Number".tr,
                hintText: "223 665 7896".tr,
                isEnabled: false,
                initialCountryCode:
                    controller.user.value.getPhoneNumber()?.countryISOCode,
                initialValue: controller.user.value.getPhoneNumber()?.number,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
                onSaved: (phone) {
                  return controller.user.value.phoneNumber =
                      phone.completeNumber;
                },

                // suffix: controller.user.value.verifiedPhone
                //     ? Text(
                //         "Verified".tr,
                //         style: Get.textTheme.caption
                //             .merge(TextStyle(color: Colors.green)),
                //       )
                //     : Text(
                //         "Not Verified".tr,
                //         style: Get.textTheme.caption
                //             .merge(TextStyle(color: Colors.redAccent)),
                //       ),
              ),

              // PhoneFieldWidget(
              //   labelText: "Whatsapp Number".tr,
              //   hintText: "223 665 7896".tr,
              //   isEnabled: true,
              //   initialCountryCode:
              //       controller.user.value.getPhoneNumber()?.countryISOCode,
              //   initialValue: controller.user.value.getPhoneNumber()?.number,
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 13),
              //   onSaved: (phone) {
              //     return controller.user.value.phoneNumber =
              //         phone.completeNumber;
              //   },

              //   // suffix: controller.user.value.verifiedPhone
              //   //     ? Text(
              //   //         "Verified".tr,
              //   //         style: Get.textTheme.caption
              //   //             .merge(TextStyle(color: Colors.green)),
              //   //       )
              //   //     : Text(
              //   //         "Not Verified".tr,
              //   //         style: Get.textTheme.caption
              //   //             .merge(TextStyle(color: Colors.redAccent)),
              //   //       ),
              // ),

              // TextFieldWidget(
              //   onChanged: (input) => controller.user.value.address = input,
              //   validator: (input) => input.length < 3
              //       ? "Should be more than 3 letters".tr
              //       : null,
              //   initialValue: controller.user.value.address,
              //   hintText: "123 Street, City 136, State, Country".tr,
              //   labelText: "Address".tr,
              //   iconData: Icons.map_outlined,
              // ),
              TextFieldWidget(
                onChanged: (input) => controller.user.value.bio = input,
                initialValue: controller.user.value.bio,
                hintText: "Your short biography here".tr,
                labelText: "Short Biography".tr,
                iconData: Icons.article_outlined,
              ),

              TextFieldWidget(
                onChanged: (input) => controller.user.value.address = input,
                validator: (input) => input.length < 3
                    ? "Should be more than 3 letters".tr
                    : null,
                initialValue: controller.user.value.address,
                hintText: "123 Street, City 136, State, Country".tr,
                labelText: "Address".tr,
                iconData: Icons.map_outlined,
              ),

              TextFieldWidget(
                labelText: "Pin code".tr,
                hintText: "".tr,
                initialValue: controller.user.value.pincode,
                onChanged: (input) => controller.user.value.pincode = input,
                validator: null,
                iconData: Icons.alternate_email,
                isFirst: true,
                isLast: false,
              ),

              Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.focusColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                    border: Border.all(
                        color: Get.theme.focusColor.withOpacity(0.05))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "State: " + controller.user.value.state.toString()),
                      ),
                    ),
                    Obx(
                      () => DropdownSearch<States>(
                        mode: Mode.MENU,
                        showSearchBox: true,
                        selectedItem: selectedState,
                        itemAsString: (States state) => state.stateName,
                        dropdownSearchDecoration:
                            InputDecoration(hintText: "Select State"),
                        items: controller.getDropdownForStates(),
                        onChanged: (val) async {
                          List<States> stats = [];
                          selectedState = val;
                          controller.user.value.state = val.stateName;
                          stats.add(selectedState);

                          controller
                              .getPlaces(selectedState.stateId.toString());
                          controller.regProvider.update((val) {
                            val.state = selectedState.stateName;
                          });
                          selectedState = val;
                        },
                        //hint: Text("Select Category"),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.focusColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                    border: Border.all(
                        color: Get.theme.focusColor.withOpacity(0.05))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("City: " + controller.user.value.city))),
                    Obx(
                      () => DropdownSearch<Places>(
                        mode: Mode.MENU,
                        showSearchBox: true,
                        selectedItem: selectedPlace,
                        itemAsString: (Places city) => city.cityName,
                        dropdownSearchDecoration:
                            InputDecoration(hintText: "Select City"),
                        items: controller.getDropdownForPlaces(),
                        onChanged: (val) async {
                          List<Places> stats = [];
                          selectedPlace = val;
                          controller.user.value.city = val.cityName;
                          stats.add(selectedPlace);

                          controller.regProvider.update((val) {
                            val.city = selectedPlace.cityName;
                          });
                          selectedPlace = val;
                        },
                        //hint: Text("Select Category"),
                      ),
                    ),
                  ],
                ),
              ),

              // Text("Change password".tr, style: Get.textTheme.headline5)
              //     .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              // Text(
              //         "Fill your old password and type new password and confirm it"
              //             .tr,
              //         style: Get.textTheme.caption)
              //     .paddingSymmetric(horizontal: 22, vertical: 5),
              // Obx(() {
              //   return TextFieldWidget(
              //     labelText: "New Password".tr,
              //     hintText: "••••••••••••".tr,
              //     onSaved: (input) => controller.newPassword.value = input,
              //     onChanged: (input) => controller.newPassword.value = input,
              //     validator: (input) {
              //       if (input.length > 0 && input.length < 3) {
              //         return "Should be more than 3 letters".tr;
              //       } else if (input != controller.confirmPassword.value) {
              //         return "Passwords do not match".tr;
              //       } else {
              //         return null;
              //       }
              //     },
              //     initialValue: controller.newPassword.value,
              //     obscureText: controller.hidePassword.value,
              //     iconData: Icons.lock_outline,
              //     keyboardType: TextInputType.visiblePassword,
              //     isFirst: false,
              //     isLast: false,
              //     suffixIcon: IconButton(
              //       onPressed: () {
              //         controller.hidePassword.value =
              //             !controller.hidePassword.value;
              //       },
              //       color: Theme.of(context).focusColor,
              //       icon: Icon(controller.hidePassword.value
              //           ? Icons.visibility_outlined
              //           : Icons.visibility_off_outlined),
              //     ),
              //   );
              // }),
              // Obx(() {
              //   return TextFieldWidget(
              //     labelText: "Confirm New Password".tr,
              //     hintText: "••••••••••••".tr,
              //     onSaved: (input) => controller.confirmPassword.value = input,
              //     onChanged: (input) =>
              //         controller.confirmPassword.value = input,
              //     validator: (input) {
              //       if (input.length > 0 && input.length < 3) {
              //         return "Should be more than 3 letters".tr;
              //       } else if (input != controller.newPassword.value) {
              //         return "Passwords do not match".tr;
              //       } else {
              //         return null;
              //       }
              //     },
              //     initialValue: controller.confirmPassword.value,
              //     obscureText: controller.hidePassword2.value,
              //     iconData: Icons.lock_outline,
              //     keyboardType: TextInputType.visiblePassword,
              //     isFirst: false,
              //     isLast: true,
              //     suffixIcon: IconButton(
              //       onPressed: () {
              //         controller.hidePassword2.value =
              //             !controller.hidePassword2.value;
              //       },
              //       color: Theme.of(context).focusColor,
              //       icon: Icon(controller.hidePassword2.value
              //           ? Icons.visibility_outlined
              //           : Icons.visibility_off_outlined),
              //     ),
              //   );
              // }),
            ],
          ),
        ));
  }
}
