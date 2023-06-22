import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/multi_select_dialog_services.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/e_service_form_controller.dart';

class EServiceFormView extends GetView<EServiceFormController> {
  List<EService> services = [];
  dynamic selectedServices;
  List<Category> selectedCategory;
  Category selectedSubcategory;
  List<Category> subcategories = <Category>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm()
                  ? "Select a service".tr
                  : controller.eService.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () {
              Get.offNamed(Routes.ROOT);
            },
          ),
          elevation: 0,
          actions: [
            if (!controller.isCreateForm())
              new IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20),
                icon: new Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () => _showDeleteDialog(context),
              ),
          ],
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
                    if (controller.isCreateForm()) {
                      controller.createEServiceForm();
                    } else {
                      controller.updateEServiceForm();
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                ),
              ),
              if (controller.isCreateForm()) SizedBox(width: 10),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.eServiceForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Service details".tr, style: Get.textTheme.headline5)
                    .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details and save them".tr,
                        style: Get.textTheme.caption)
                    .paddingSymmetric(horizontal: 22, vertical: 5),
                TextFieldWidget(
                  onChanged: (input) =>
                      controller.eService.value.description = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.eService.value.description,
                  hintText: "Description for Post Party Cleaning".tr,
                  labelText: "Description".tr,
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
                        () => DropdownSearch<Category>(
                          mode: Mode.MENU,
                          showSearchBox: true,
                          itemAsString: (Category cat) => cat.name.toString(),
                          dropdownSearchDecoration:
                              InputDecoration(hintText: "Select Category"),
                          items: controller.getDropdownForCategories(),
                          onChanged: (val) async {
                            selectedCategory = [val];
                            controller.eService.update((val) {
                              controller.eService.value.subCategories =
                                  selectedCategory[0].subCategories;
                            });

                            subcategories = selectedCategory[0].subCategories;
                            selectedCategory[0].eServices =
                                await EServiceFormController()
                                    .getEService(selectedCategory[0].id);
                            print("Selected Category: " +
                                selectedCategory[0].name);
                            print("SubCategories:" +
                                controller.eService.value.subCategories
                                    .toString());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                selectedCategory != null &&
                        selectedCategory[0].subCategories.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 10, left: 20, right: 20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
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
                              () => DropdownSearch<Category>(
                                mode: Mode.MENU,
                                showSearchBox: true,
                                itemAsString: (Category cat) {
                                  return cat.name;
                                },
                                dropdownSearchDecoration: InputDecoration(
                                    hintText: "Select Subcategory"),
                                items: controller.eService.value.subCategories,
                                onChanged: (val) async {
                                  selectedSubcategory = val;
                                  controller.eService.update((val) {
                                    val.subCategories = val.subCategories;
                                  });
                                  selectedCategory[0].eServices =
                                      await EServiceFormController()
                                          .getEService(selectedCategory[0].id);
                                },
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Services".tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (selectedCategory != null) {
                                services = await EServiceFormController()
                                    .getEService(selectedCategory[0].id);
                                selectedServices =
                                    await showDialog<Set<EService>>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MultiSelectDialogService(
                                      title: "Select Services".tr,
                                      submitText: "Submit".tr,
                                      cancelText: "Cancel".tr,
                                      items: controller
                                          .getMultiSelectServicesItems(
                                              List<EService>.from(services)),
                                    );
                                  },
                                );
                                controller.eService.update((val) {
                                  val.services =
                                      selectedServices?.toList() ?? [];
                                });
                                subcategories = await controller
                                    .getDropdownForSubCategories(
                                        selectedCategory[0].id);
                              }
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary
                                .withOpacity(0.1),
                            child: Text("Select".tr,
                                style: Get.textTheme.subtitle1),
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.eService?.value?.categories?.isEmpty ==
                                true ||
                            selectedServices == null ||
                            List.from(selectedServices).isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Select services".tr,
                              style: Get.textTheme.caption,
                            ),
                          );
                        } else {
                          return buildServices(List.from(selectedServices));
                        }
                      })
                    ],
                  ),
                ),
                Obx(() {
                  if (controller.eProviders.length > 1)
                    return Container(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Providers".tr,
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  final selectedValue =
                                      await showDialog<EProvider>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectDialog(
                                        title: "Select Provider".tr,
                                        submitText: "Submit".tr,
                                        cancelText: "Cancel".tr,
                                        items: controller
                                            .getSelectProvidersItems(),
                                        initialSelectedValue:
                                            controller.eProviders.firstWhere(
                                          (element) =>
                                              element.id ==
                                              controller
                                                  .eService.value.eProvider?.id,
                                          orElse: () => new EProvider(),
                                        ),
                                      );
                                    },
                                  );
                                  controller.eService.update((val) {
                                    val.eProvider = selectedValue;
                                  });
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary
                                    .withOpacity(0.1),
                                child: Text("Select".tr,
                                    style: Get.textTheme.subtitle1),
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                              ),
                            ],
                          ),
                          Obx(() {
                            if (controller.eService.value?.eProvider == null) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Select providers".tr,
                                  style: Get.textTheme.caption,
                                ),
                              );
                            } else {
                              return buildProvider(controller.eService.value);
                            }
                          })
                        ],
                      ),
                    );
                  else if (controller.eProviders.length == 1) {
                    controller.eService.value.eProvider =
                        controller.eProviders.first;
                    return SizedBox();
                  } else {
                    return SizedBox();
                  }
                }),

                TextFieldWidget(
                  labelText: "Experience (in yrs.)".tr,
                  hintText: "Enter your experience".tr,
                  initialValue: controller.regProvider.value.yearsOfExperience,
                  onChanged: (input) =>
                      controller.regProvider.value.yearsOfExperience = input,
                  validator: null,
                  isFirst: false,
                  isLast: false,
                ),

                SizedBox(
                  height: 10.0,
                ),

                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    field: 'image',
                    tag: controller.eServiceForm.hashCode.toString(),
                    initialImages: controller.eService.value.images,
                    uploadCompleted: (uuid) {
                      controller.eService.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.eService.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),

                SizedBox(
                  height: 10,
                ),

                // Text(controller.regProvider.value.yearsOfExperience.toString()),
              ],
            ),
          ),
        ));
  }

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories?.length ?? 0, (index) {
              var _category = _eService.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name,
                    style: Get.textTheme.bodyText1
                        .merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_eService.subCategories?.length ?? 0, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories.elementAt(index).name,
                    style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildServices(List<EService> _eService) {
    if (_eService.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 8,
            children: List.generate(_eService.length ?? 0, (index) {
              var _category = _eService.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name, style: Get.textTheme.bodyText1),
              );
            })),
      );
    } else
      return SizedBox.shrink();
  }

  Widget buildProvider(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_eService.eProvider?.name ?? '',
            style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Service".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This service will removed from your account".tr,
                    style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteEService();
              },
            ),
          ],
        );
      },
    );
  }
}
