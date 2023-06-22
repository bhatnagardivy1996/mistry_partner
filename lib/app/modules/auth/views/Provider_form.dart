// ignore_for_file: must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/media_model.dart';
import '../../../models/provider_registration.dart';
import '../../../models/register_places.dart';
import '../../../models/register_state.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class ProviderFormView extends GetView<AuthController> {
  States selectedState;
  Places selectedPlace;
  EProviderType providerType =
      EProviderType(id: "0", name: "NA", commission: 0.0);

  init() async {
    await controller.getServiceCategories();
    await controller.getProvidertype().then((value) async {
      for (int i = 0; i < controller.typelist.length; i++) {
        if (controller.typelist.elementAt(i).id ==
            controller.currentUser.value.providerTypeId) {
          controller.currentUser.update((val) {
            val.providerTypeId = controller.typelist.elementAt(i).id;
            val.providerTypeName = controller.typelist.elementAt(i).name;
          });
          //providerType = controller.typelist.elementAt(i);
        }
      }
    });
    await controller.getStateslist();
  }

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    GlobalKey<FormState> addressKey = GlobalKey<FormState>();
    GlobalKey<FormState> idKey = GlobalKey<FormState>();
    init();
    return WillPopScope(
      onWillPop: () {
        Get.offAllNamed(Routes.ROOT, arguments: 0);
        return;
      },
      child: Scaffold(
        body: Form(
          key: controller.providerFormKey,
          child: ListView(
            primary: true,
            children: [
              Obx(() {
                return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      height: 160,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(10)),
                      ),
                      margin: EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.ROOT,
                                          arguments: 0);
                                    },
                                    child: Icon(Icons.arrow_back_ios)),
                                Text(
                                  controller.scrollIndex == 0
                                      ? "ADD YOUR SERVICE"
                                      : "MISTRY YOURSELF",
                                  style: Get.textTheme.titleLarge.merge(
                                      TextStyle(
                                          color: Colors.black, fontSize: 24)),
                                ).paddingOnly(left: 60),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              controller.scrollIndex == 1
                                  ? "VERIFY YOUR ACCOUNT".tr
                                  : "",
                              style: Get.textTheme.bodySmall
                                  .merge(TextStyle(color: Colors.black)),
                              textAlign: TextAlign.center,
                            ),
                            // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
                          ]
                        : [
                            // Obx(() {
                            //   return TextFieldWidget(
                            //     labelText: "Aadhaar Card Number".tr,
                            //     hintText: "Aadhaar Card Number".tr,
                            //     initialValue:
                            //         controller.currentUser?.value?.aadharNo,
                            //     onChanged: (input) => controller
                            //         .currentUser?.value?.aadharNo = input,
                            //     validator: null,
                            //     iconData: Icons.person_outline,
                            //     isFirst: true,
                            //     isLast: false,
                            //   );
                            // }),

                            TextFieldWidget(
                              labelText: "Permanent Address".tr,
                              hintText: "House Flat No.".tr,
                              enabled: false,
                              initialValue:
                                  controller.currentUser.value.address +
                                      ", " +
                                      controller.currentUser.value.city +
                                      ", " +
                                      controller.currentUser.value.state +
                                      ", " +
                                      controller.currentUser.value.pincode,
                              // onChanged: (input) =>
                              //     controller.currentUser.value.address = input,
                              validator: null,
                              iconData: Icons.location_city,
                              isFirst: false,
                              isLast: false,
                            ),
                            // TextFieldWidget(
                            //   labelText: "Area, street sector".tr,
                            //   hintText: "".tr,
                            //   initialValue: controller.area.value,
                            //   onChanged: (input) =>
                            //       controller.area?.value = input,
                            //   validator: null,
                            //   iconData: Icons.alternate_email,
                            //   isFirst: false,
                            //   isLast: false,
                            // ),
                            // TextFieldWidget(
                            //   labelText: "Pin code".tr,
                            //   hintText: "".tr,
                            //   initialValue:
                            //       controller.currentUser.value.pincode,
                            //   onChanged: (input) =>
                            //       controller.currentUser.value.pincode = input,
                            //   validator: null,
                            //   iconData: Icons.alternate_email,
                            //   isFirst: false,
                            //   isLast: false,
                            // ),

                            // Container(
                            //     padding: EdgeInsets.only(
                            //         top: 8, bottom: 10, left: 20, right: 20),
                            //     margin: EdgeInsets.only(
                            //         left: 20, right: 20, top: 20, bottom: 20),
                            //     decoration: BoxDecoration(
                            //         color: Get.theme.primaryColor,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10)),
                            //         boxShadow: [
                            //           BoxShadow(
                            //               color: Get.theme.focusColor
                            //                   .withOpacity(0.1),
                            //               blurRadius: 10,
                            //               offset: Offset(0, 5)),
                            //         ],
                            //         border: Border.all(
                            //             color: Get.theme.focusColor
                            //                 .withOpacity(0.05))),
                            //     child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.stretch,
                            //         children: [
                            //           Obx(
                            //             () => Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                   vertical: 8.0),
                            //               child: Text("State: " +
                            //                   controller.currentUser.value.state
                            //                       .toString()),
                            //             ),
                            //           ),
                            //           Obx(
                            //             () => DropdownSearch<States>(
                            //               mode: Mode.MENU,
                            //               showSearchBox: true,
                            //               selectedItem: selectedState,
                            //               itemAsString: (States state) =>
                            //                   state.stateName,
                            //               dropdownSearchDecoration:
                            //                   InputDecoration(
                            //                       hintText: "Select State"),
                            //               items:
                            //                   controller.getDropdownForStates(),
                            //               onChanged: (val) async {
                            //                 List<States> stats = [];
                            //                 selectedState = val;
                            //                 controller.currentUser.value.state =
                            //                     val.stateName;
                            //                 stats.add(selectedState);
                            // Container(
                            //     padding: EdgeInsets.only(
                            //         top: 8, bottom: 10, left: 20, right: 20),
                            //     margin: EdgeInsets.only(
                            //         left: 20, right: 20, top: 20, bottom: 20),
                            //     decoration: BoxDecoration(
                            //         color: Get.theme.primaryColor,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10)),
                            //         boxShadow: [
                            //           BoxShadow(
                            //               color: Get.theme.focusColor
                            //                   .withOpacity(0.1),
                            //               blurRadius: 10,
                            //               offset: Offset(0, 5)),
                            //         ],
                            //         border: Border.all(
                            //             color: Get.theme.focusColor
                            //                 .withOpacity(0.05))),
                            //     child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.stretch,
                            //         children: [
                            //           Obx(
                            //             () => Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                   vertical: 8.0),
                            //               child: Text("State: " +
                            //                   controller.currentUser.value.state
                            //                       .toString()),
                            //             ),
                            //           ),
                            //           Obx(
                            //             () => DropdownSearch<States>(
                            //               mode: Mode.MENU,
                            //               showSearchBox: true,
                            //               selectedItem: selectedState,
                            //               itemAsString: (States state) =>
                            //                   state.stateName,
                            //               dropdownSearchDecoration:
                            //                   InputDecoration(
                            //                       hintText: "Select State"),
                            //               items:
                            //                   controller.getDropdownForStates(),
                            //               onChanged: (val) async {
                            //                 List<States> stats = [];
                            //                 selectedState = val;
                            //                 controller.currentUser.value.state =
                            //                     val.stateName;
                            //                 stats.add(selectedState);

                            //                 controller.getPlaces(selectedState
                            //                     .stateId
                            //                     .toString());
                            //                 controller.regProvider
                            //                     .update((val) {
                            //                   val.state =
                            //                       selectedState.stateName;
                            //                 });
                            //                 selectedState = val;
                            //               },
                            //               //hint: Text("Select Category"),
                            //             ),
                            //           ),
                            //         ])),
                            // Container(
                            //     padding: EdgeInsets.only(
                            //         top: 8, bottom: 10, left: 20, right: 20),
                            //     margin: EdgeInsets.only(
                            //         left: 20, right: 20, top: 20, bottom: 20),
                            //     decoration: BoxDecoration(
                            //         color: Get.theme.primaryColor,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10)),
                            //         boxShadow: [
                            //           BoxShadow(
                            //               color: Get.theme.focusColor
                            //                   .withOpacity(0.1),
                            //               blurRadius: 10,
                            //               offset: Offset(0, 5)),
                            //         ],
                            //         border: Border.all(
                            //             color: Get.theme.focusColor
                            //                 .withOpacity(0.05))),
                            //     child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.stretch,
                            //         children: [
                            //           Obx(() => Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                   vertical: 8.0),
                            //               child: Text("City: " +
                            //                   controller
                            //                       .currentUser.value.city))),
                            //           Obx(
                            //             () => DropdownSearch<Places>(
                            //               mode: Mode.MENU,
                            //               showSearchBox: true,
                            //               selectedItem: selectedPlace,
                            //               itemAsString: (Places city) =>
                            //                   city.cityName,
                            //               dropdownSearchDecoration:
                            //                   InputDecoration(
                            //                       hintText: "Select City"),
                            //               items:
                            //                   controller.getDropdownForPlaces(),
                            //               onChanged: (val) async {
                            //                 List<Places> stats = [];
                            //                 selectedPlace = val;
                            //                 controller.currentUser.value.city =
                            //                     val.cityName;
                            //                 stats.add(selectedPlace);
                            //                 controller.getPlaces(selectedState
                            //                     .stateId
                            //                     .toString());
                            //                 controller.regProvider
                            //                     .update((val) {
                            //                   val.state =
                            //                       selectedState.stateName;
                            //                 });
                            //                 selectedState = val;
                            //               },
                            //               //hint: Text("Select Category"),
                            //             ),
                            //           ),
                            //         ])),
                            // Container(
                            //     padding: EdgeInsets.only(
                            //         top: 8, bottom: 10, left: 20, right: 20),
                            //     margin: EdgeInsets.only(
                            //         left: 20, right: 20, top: 20, bottom: 20),
                            //     decoration: BoxDecoration(
                            //         color: Get.theme.primaryColor,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10)),
                            //         boxShadow: [
                            //           BoxShadow(
                            //               color: Get.theme.focusColor
                            //                   .withOpacity(0.1),
                            //               blurRadius: 10,
                            //               offset: Offset(0, 5)),
                            //         ],
                            //         border: Border.all(
                            //             color: Get.theme.focusColor
                            //                 .withOpacity(0.05))),
                            //     child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.stretch,
                            //         children: [
                            //           Obx(() => Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                   vertical: 8.0),
                            //               child: Text("City: " +
                            //                   controller
                            //                       .currentUser.value.city))),
                            //           Obx(
                            //             () => DropdownSearch<Places>(
                            //               mode: Mode.MENU,
                            //               showSearchBox: true,
                            //               selectedItem: selectedPlace,
                            //               itemAsString: (Places city) =>
                            //                   city.cityName,
                            //               dropdownSearchDecoration:
                            //                   InputDecoration(
                            //                       hintText: "Select City"),
                            //               items:
                            //                   controller.getDropdownForPlaces(),
                            //               onChanged: (val) async {
                            //                 List<Places> stats = [];
                            //                 selectedPlace = val;
                            //                 controller.currentUser.value.city =
                            //                     val.cityName;
                            //                 stats.add(selectedPlace);

                            //                 controller.regProvider
                            //                     .update((val) {
                            //                   val.city = selectedPlace.cityName;
                            //                 });
                            //                 selectedPlace = val;
                            //               },
                            //               //hint: Text("Select Category"),
                            //             ),
                            //           ),
                            //         ])),
                            //                 controller.regProvider
                            //                     .update((val) {
                            //                   val.city = selectedPlace.cityName;
                            //                 });
                            //                 selectedPlace = val;
                            //               },
                            //               //hint: Text("Select Category"),
                            //             ),
                            //           ),
                            //         ])),
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
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Text("Provider Type: "),
                                              Obx(() => Text(controller
                                                      .currentUser
                                                      ?.value
                                                      ?.providerTypeName
                                                      ?.toString() ??
                                                  "")),
                                            ],
                                          )),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Change Provider Type".tr,
                                              style: Get.textTheme.bodyLarge,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              final selectedValue =
                                                  await showDialog<
                                                      EProviderType>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SelectDialog(
                                                    title:
                                                        "Select Provider type"
                                                            .tr,
                                                    submitText: "Submit".tr,
                                                    cancelText: "Cancel".tr,
                                                    items:
                                                        controller.getProType(),
                                                    initialSelectedValue:
                                                        controller.typelist
                                                            .firstWhere(
                                                      (element) =>
                                                          element.id ==
                                                          controller
                                                              .currentUser
                                                              .value
                                                              ?.providerTypeId,
                                                      orElse: () =>
                                                          new EProviderType(),
                                                    ),
                                                  );
                                                },
                                              );
                                              controller.regProvider
                                                  .update((val) {
                                                val.providertype =
                                                    selectedValue.name;
                                                providerType = selectedValue;
                                              });
                                              controller.currentUser
                                                  .update((val) {
                                                val.providerTypeId =
                                                    selectedValue.id;
                                                val.providerTypeName =
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
                                      // if (providerType != null)
                                      //   Text(providerType.name.toString())
                                    ])),
                            Wrap(
                              children: [
                                ImagesFieldWidget(
                                  label: "Address Proof".tr,
                                  field: 'Address Proof',
                                  tag: addressKey.hashCode.toString(),
                                  initialImages: controller
                                          .currentUser.value.media
                                          .where((element) =>
                                              element.type == "address_proof")
                                          .toList() ??
                                      controller.regProvider.value.addressProof,
                                  uploadCompleted: (uuid) {
                                    controller.regProvider.update((val) {
                                      val.addressProof = val.addressProof ?? [];
                                      val.addressProof.add(new Media(id: uuid));
                                    });
                                  },
                                  reset: (uuids) {
                                    controller.regProvider.update((val) {
                                      val.addressProof?.clear();
                                    });
                                  },
                                ),
                                ImagesFieldWidget(
                                  label: "Id Proof".tr,
                                  field: 'Id Proof',
                                  tag: idKey.hashCode.toString(),
                                  initialImages: controller
                                          .currentUser.value.media
                                          .where((element) =>
                                              element.type == "id_proof")
                                          .toList() ??
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
                              ],
                            ),
                          ],
                  ),
                );
              }),
              SizedBox(
                height: 120,
              )
            ],
          ),
        ),
        bottomNavigationBar: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              // crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: BlockButtonWidget(
                        onPressed: () {
                          if (controller.scrollIndex == 0) {
                            controller.setScrollIndex(1);
                          } else {
                            controller.registerprovider();
                            // Get.offAllNamed(Routes.PHONE_VERIFICATION);
                          }
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          controller.scrollIndex == 0
                              ? "Next".tr
                              : "KYC Update".tr,
                          style: Get.textTheme.titleLarge
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 15, left: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed(Routes.ROOT, arguments: 0);
                      },
                      child: Text(controller.frombook.isFalse
                          ? "skip,\ni'll do this later".tr
                          : "".tr),
                    ).paddingOnly(bottom: 10, left: 240),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       onPressed: () {
                //         Get.offAllNamed(Routes.ROOT, arguments: 0);
                //       },
                //       child:
                //           Text(controller.frombook.isTrue ? "back".tr : "".tr),
                //     ).paddingOnly(bottom: 10),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
