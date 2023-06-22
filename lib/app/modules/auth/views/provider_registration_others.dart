import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/provider_registration.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class ProviderFormView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    controller.getServiceCategories();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Provider Register".tr,
            style: Get.textTheme.titleLarge
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
          key: controller.providerFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 160,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.providerAppName,
                            style: Get.textTheme.titleLarge.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best service provider system!".tr,
                            style: Get.textTheme.bodySmall.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border:
                          Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              // HorizontalStepperWidget(
              //   steps: [
              //     StepWidget(
              //       title: Text(
              //         ("Service details".tr)
              //             .substring(0, min("Service details".tr.length, 15)),
              //       ),
              //       color: Get.theme.focusColor,
              //       index: Text("1",
              //           style: TextStyle(color: Get.theme.primaryColor)),
              //     ),
              //     StepWidget(
              //       title: Text(
              //         ("Options details".tr)
              //             .substring(0, min("Others details".tr.length, 15)),
              //       ),
              //       color: Get.theme.focusColor,
              //       index: Text("2",
              //           style: TextStyle(color: Get.theme.primaryColor)),
              //     ),
              //   ],
              // ),
              Obx(() {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: controller.scrollIndex == 0
                        ? [
                            Container(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 10, left: 20, right: 20),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Service Category".tr,
                                              style: Get.textTheme.bodyLarge,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              final selectedValue =
                                                  await showDialog<CatService>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SelectDialog(
                                                    title:
                                                        "Select Service Category"
                                                            .tr,
                                                    submitText: "Submit".tr,
                                                    cancelText: "Cancel".tr,
                                                    items: controller
                                                        .getCategories(),
                                                    initialSelectedValue:
                                                        controller
                                                            .servicesCategory
                                                            .firstWhere(
                                                      (element) =>
                                                          element.name ==
                                                          controller.regProvider
                                                              .value?.category,
                                                      orElse: () =>
                                                          new CatService(),
                                                    ),
                                                  );
                                                },
                                              );
                                              controller.regProvider
                                                  .update((val) {
                                                controller.getServices(
                                                    selectedValue.id
                                                        .toString());
                                                val.category =
                                                    selectedValue.name;
                                              });
                                            },
                                            shape: StadiumBorder(),
                                            color: Get
                                                .theme.colorScheme.secondary
                                                .withOpacity(0.1),
                                            child: Text("Select".tr,
                                                style:
                                                    Get.textTheme.titleMedium),
                                            elevation: 0,
                                            hoverElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                          ),
                                        ],
                                      ),
                                    ])),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 10, left: 20, right: 20),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Service".tr,
                                              style: Get.textTheme.bodyLarge,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              final selectedValue =
                                                  await showDialog<CatService>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SelectDialog(
                                                    title: "Select Service".tr,
                                                    submitText: "Submit".tr,
                                                    cancelText: "Cancel".tr,
                                                    items:
                                                        controller.getService(),
                                                    initialSelectedValue:
                                                        controller
                                                            .servicesCategory
                                                            .firstWhere(
                                                      (element) =>
                                                          element.name ==
                                                          controller.regProvider
                                                              .value?.services,
                                                      orElse: () =>
                                                          new CatService(),
                                                    ),
                                                  );
                                                },
                                              );
                                              controller.regProvider
                                                  .update((val) {
                                                val.services =
                                                    selectedValue.name;
                                              });
                                            },
                                            shape: StadiumBorder(),
                                            color: Get
                                                .theme.colorScheme.secondary
                                                .withOpacity(0.1),
                                            child: Text("Select".tr,
                                                style:
                                                    Get.textTheme.titleMedium),
                                            elevation: 0,
                                            hoverElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                          ),
                                        ],
                                      ),
                                    ])),
                            TextFieldWidget(
                              labelText: "Description".tr,
                              hintText: "Description".tr,
                              initialValue:
                                  controller.regProvider.value?.description,
                              onChanged: (input) => controller
                                  .regProvider.value?.description = input,
                              validator: null,
                              iconData: Icons.school,
                              isFirst: false,
                              isLast: false,
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Text(
                            //         "mm/dd/yyyy".tr,
                            //         style: Get.textTheme.bodyText1,
                            //         textAlign: TextAlign.start,
                            //       ),
                            //     ),
                            //     MaterialButton(
                            //       onPressed: () async {
                            //         // final picked = await Ui.showTimePickerDialog(
                            //         //     context,
                            //         //     controller.availabilityHour.value.endAt);
                            //         // controller.availabilityHour.update((val) {
                            //         //   val.endAt = picked;
                            //         // });
                            //       },
                            //       shape: StadiumBorder(),
                            //       color: Get.theme.colorScheme.secondary
                            //           .withOpacity(0.1),
                            //       child: Text("Time Picker".tr,
                            //           style: Get.textTheme.subtitle1),
                            //       elevation: 0,
                            //       hoverElevation: 0,
                            //       focusElevation: 0,
                            //       highlightElevation: 0,
                            //     ),
                            //   ],
                            // ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5)),
                                  ],
                                  border: Border.all(
                                      color: Get.theme.focusColor
                                          .withOpacity(0.05))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Expirience".tr,
                                    style: Get.textTheme.bodyLarge,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 10),
                                  Obx(() {
                                    return ListTileTheme(
                                      contentPadding: EdgeInsets.all(0.0),
                                      horizontalTitleGap: 0,
                                      dense: true,
                                      textColor: Get.theme.hintColor,
                                      child: ListBody(
                                        children: [
                                          RadioListTile(
                                            value: "yes",
                                            groupValue: controller
                                                .regProvider.value.experience,
                                            selected: controller.regProvider
                                                    .value.experience ==
                                                "yes",
                                            title: Text("Yes".tr),
                                            activeColor:
                                                Get.theme.colorScheme.secondary,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            onChanged: (checked) {
                                              controller.regProvider
                                                  .update((val) {
                                                val.experience = "yes";
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            value: "no",
                                            groupValue: controller
                                                .regProvider.value.experience,
                                            title: Text("No".tr),
                                            activeColor:
                                                Get.theme.colorScheme.secondary,
                                            selected: controller.regProvider
                                                    .value.experience ==
                                                "no",
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            onChanged: (checked) {
                                              controller.regProvider
                                                  .update((val) {
                                                val.experience = "no";
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),

                            // TextFieldWidget(
                            //   labelText: "Service".tr,
                            //   hintText: "".tr,
                            //   initialValue: controller.regProvider?.value?.services,
                            //   onChanged: (input) =>
                            //       controller.regProvider?.value?.services = input,
                            //   validator: null,
                            //   iconData: Icons.school,
                            //   isFirst: false,
                            //   isLast: false,
                            // ),
                          ]
                        : [
                            Obx(() {
                              return TextFieldWidget(
                                labelText: "Aadhar Number".tr,
                                hintText: "Aadhar Number".tr,
                                initialValue:
                                    controller.regProvider?.value?.aadhaarNo,
                                onChanged: (input) => controller
                                    .regProvider?.value?.aadhaarNo = input,
                                validator: null,
                                iconData: Icons.person_outline,
                                isFirst: true,
                                isLast: false,
                              );
                            }),

                            TextFieldWidget(
                              labelText: "Permenant Address".tr,
                              hintText: "Address".tr,
                              initialValue:
                                  controller.regProvider?.value?.address,
                              onChanged: (input) => controller
                                  .regProvider?.value?.address = input,
                              validator: null,
                              iconData: Icons.alternate_email,
                              isFirst: false,
                              isLast: false,
                            ),

                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Text(
                            //         "mm/dd/yyyy".tr,
                            //         style: Get.textTheme.bodyText1,
                            //         textAlign: TextAlign.start,
                            //       ),
                            //     ),
                            //     MaterialButton(
                            //       onPressed: () async {
                            //         // final picked = await Ui.showTimePickerDialog(
                            //         //     context,
                            //         //     controller.availabilityHour.value.endAt);
                            //         // controller.availabilityHour.update((val) {
                            //         //   val.endAt = picked;
                            //         // });
                            //       },
                            //       shape: StadiumBorder(),
                            //       color: Get.theme.colorScheme.secondary
                            //           .withOpacity(0.1),
                            //       child: Text("Time Picker".tr,
                            //           style: Get.textTheme.subtitle1),
                            //       elevation: 0,
                            //       hoverElevation: 0,
                            //       focusElevation: 0,
                            //       highlightElevation: 0,
                            //     ),
                            //   ],
                            // ),

                            TextFieldWidget(
                              labelText: "Education".tr,
                              hintText: "Education".tr,
                              initialValue:
                                  controller.regProvider?.value?.education,
                              onChanged: (input) => controller
                                  .regProvider?.value?.education = input,
                              validator: null,
                              iconData: Icons.school,
                              isFirst: false,
                              isLast: false,
                            ),
                            TextFieldWidget(
                              labelText: "Certification".tr,
                              hintText: "Certification".tr,
                              initialValue:
                                  controller.regProvider?.value?.certification,
                              onChanged: (input) => controller
                                  .regProvider?.value?.certification = input,
                              validator: null,
                              iconData: Icons.school,
                              isFirst: false,
                              isLast: false,
                            ),
                            // TextFieldWidget(
                            //   labelText: "Service".tr,
                            //   hintText: "".tr,
                            //   initialValue: controller.regProvider?.value?.services,
                            //   onChanged: (input) =>
                            //       controller.regProvider?.value?.services = input,
                            //   validator: null,
                            //   iconData: Icons.school,
                            //   isFirst: false,
                            //   isLast: false,
                            // ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5)),
                                  ],
                                  border: Border.all(
                                      color: Get.theme.focusColor
                                          .withOpacity(0.05))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Gender".tr,
                                    style: Get.textTheme.bodyLarge,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 10),
                                  Obx(() {
                                    return ListTileTheme(
                                      contentPadding: EdgeInsets.all(0.0),
                                      horizontalTitleGap: 0,
                                      dense: true,
                                      textColor: Get.theme.hintColor,
                                      child: ListBody(
                                        children: [
                                          RadioListTile(
                                            value: "male",
                                            groupValue: controller
                                                .regProvider.value.gender,
                                            selected: controller
                                                    .regProvider.value.gender ==
                                                "male",
                                            title: Text("Male".tr),
                                            activeColor:
                                                Get.theme.colorScheme.secondary,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            onChanged: (checked) {
                                              controller.regProvider
                                                  .update((val) {
                                                val.gender = "male";
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            value: "female",
                                            groupValue: controller
                                                .regProvider.value.gender,
                                            title: Text("Female".tr),
                                            activeColor:
                                                Get.theme.colorScheme.secondary,
                                            selected: controller
                                                    .regProvider.value.gender ==
                                                "female",
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            onChanged: (checked) {
                                              controller.regProvider
                                                  .update((val) {
                                                val.gender = "female";
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),

                            TextFieldWidget(
                              labelText: "Other Information".tr,
                              hintText: "Other Information".tr,
                              initialValue: controller
                                  .regProvider?.value?.yearsOfExperience,
                              onChanged: (input) => controller.regProvider
                                  ?.value?.yearsOfExperience = input,
                              validator: null,
                              iconData: Icons.school,
                              isFirst: false,
                              isLast: false,
                            ),
                            ImagesFieldWidget(
                              label: "Address Proof".tr,
                              field: 'Address Proof',
                              tag: controller.providerFormKey.hashCode
                                  .toString(),
                              initialImages:
                                  controller.regProvider.value.addressProof,
                              uploadCompleted: (uuid) {
                                controller.regProvider.update((val) {
                                  val.addressProof = val.addressProof ?? [];
                                  val.addressProof.add(new Media(id: uuid));
                                });
                              },
                              reset: (uuids) {
                                controller.regProvider.update((val) {
                                  val.addressProof.clear();
                                });
                              },
                            ),
                            ImagesFieldWidget(
                              label: "Id Proof".tr,
                              field: 'Id Proof',
                              tag: controller.providerFormKey.hashCode
                                  .toString(),
                              initialImages:
                                  controller.regProvider.value.idProof,
                              uploadCompleted: (uuid) {
                                controller.regProvider.update((val) {
                                  val.idProof = val.idProof ?? [];
                                  val.idProof.add(new Media(id: uuid));
                                });
                              },
                              reset: (uuids) {
                                controller.regProvider.update((val) {
                                  val.idProof.clear();
                                });
                              },
                            )
                            // Obx(() {
                            //   return ImagesFieldWidget(
                            //     label: "Images".tr,
                            //     field: 'image',
                            //     tag: controller.providerFormKey.hashCode.toString(),
                            //     // initialImages: controller.providerFormKey.value.images,
                            //     // uploadCompleted: (uuid) {
                            //     //   controller.providerFormKey.update((val) {
                            //     //     val.images = val.images ?? [];
                            //     //     val.images.add(new Media(id: uuid));
                            //     //   });
                            //     // },
                            //     // reset: (uuids) {
                            //     //   controller.providerFormKey.update((val) {
                            //     //     val.images.clear();
                            //     //   });
                            //     // },
                            //   );
                            // }),
                          ],
                  ),
                );
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      // width: Get.width,
                      child: BlockButtonWidget(
                        onPressed: () {
                          controller.registerprovider();
                          // Get.offAllNamed(Routes.PHONE_VERIFICATION);
                        },
                        color: Colors.white,
                        text: Text(
                          "back".tr,
                          style: Get.textTheme.titleLarge.merge(
                              TextStyle(color: Get.theme.colorScheme.primary)),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                    ),
                    SizedBox(
                      // width: Get.width,
                      child: BlockButtonWidget(
                        onPressed: () {
                          controller.registerprovider();
                          // Get.offAllNamed(Routes.PHONE_VERIFICATION);
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "Next".tr,
                          style: Get.textTheme.titleLarge
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.ROOT, arguments: 0);
                  },
                  child: Text(controller.frombook.isFalse
                      ? "skip,i'll do this later".tr
                      : "".tr),
                ).paddingOnly(bottom: 10),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.ROOT, arguments: 0);
                  },
                  child: Text("You already have a membership?".tr),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
