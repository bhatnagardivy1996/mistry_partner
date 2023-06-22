import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/provider_registration.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/multi_select_dialog_services.dart';
import '../../global_widgets/select_dialog.dart';

class EServiceFormController extends GetxController {
  final eService = EService().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  final allcategories = <Category>[].obs;
  final services = <EService>[].obs;
  final eProviders = <EProvider>[].obs;
  final Rx<RegProvider> regProvider = RegProvider().obs;
  final isbook = false.obs;

  GlobalKey<FormState> eServiceForm = new GlobalKey<FormState>();
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;
  EProviderRepository _eProviderRepository;
  UserRepository _userRepository;

  EServiceFormController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    _eProviderRepository = new EProviderRepository();
    _userRepository = new UserRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    print(eProviders.value);
    print("arguments are ${arguments}");
    if (arguments != null) {
      eService.value = arguments['eService'] as EService;
      isbook.value = arguments['isbook'] as bool;
    }
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    //await getEService();
    await getCategories();
    await getEProviders();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future<List<EService>> getEService(String catid) async {
    try {
      List<EService> eServe = await _eServiceRepository.get(catid);
      return eServe;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      return [];
    }
  }

  Future getParentCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllWithSubCategories());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<Category> getDropdownForCategories() {
    return categories.map((element) {
      return element;
    }).toList();
  }

  List<Category> getDropdownForSubCategories(String catid) {
    for (int i = 0; i < allcategories.length; i++) {
      if (allcategories[i].id == catid) {
        print(allcategories[i].toString());
        return allcategories[i].subCategories;
      }
    }
    return [];
  }

  List<DropdownMenuItem<String>> getDropdownForServices() {
    return services.map((element) {
      return DropdownMenuItem(
        child: Text(
          element.name,
          style: TextStyle(fontSize: 12),
        ),
        value: element.id,
      );
    }).toList();
  }

  List<MultiSelectDialogItemService<EService>> getMultiSelectServicesItems(
      List<EService> srs) {
    return srs.map((element) {
      return MultiSelectDialogItemService(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<EProvider>> getSelectProvidersItems() {
    return eProviders.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  Future getOptionGroups() async {
    if (eService.value.hasData) {
      try {
        var _optionGroups =
            await _eServiceRepository.getOptionGroups(eService.value.id);
        optionGroups.assignAll(_optionGroups);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eService.value.hasData;
  }

  void createEServiceForm({bool createOptions = false}) async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      try {
        eServiceForm.currentState.save();
        //eService.value.name = "N";
        eService.value.price = 0.0;
        eService.value.priceUnit = "Fixed";
        print(eService.value);
        RegProvider reg = new RegProvider(
          yearsOfExperience: regProvider.value.yearsOfExperience,
        );

        var _eService = await _eServiceRepository.create(eService.value);
        await _userRepository.registerProvider(reg);
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Services saved successfully!"));
        if (createOptions)
          Get.offAndToNamed(Routes.OPTIONS_FORM,
              arguments: {'eService': _eService});
        else
          Get.offAndToNamed(Routes.ROOT, arguments: {
            'eService': _eService,
            'heroTag': 'e_service_create_form'
          });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEServiceForm() async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      try {
        eServiceForm.currentState.save();
        RegProvider reg = new RegProvider(
          yearsOfExperience: regProvider.value.yearsOfExperience,
        );
        var _eService = await _eServiceRepository.update(eService.value);
        await _userRepository.registerProvider(reg);
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Service saved successfully!"));
        Get.offAndToNamed(Routes.E_SERVICE, arguments: {
          'eService': _eService,
          'heroTag': 'e_service_update_form'
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteEService() async {
    try {
      await _eServiceRepository.delete(eService.value.id);
      Get.offAndToNamed(Routes.E_SERVICES);
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: eService.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
