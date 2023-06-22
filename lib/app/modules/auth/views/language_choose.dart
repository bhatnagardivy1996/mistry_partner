import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/translation_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../settings/controllers/language_controller.dart';
import '../../settings/widgets/languages_loader_widget.dart';

class LanguageStartView extends GetView<LanguageController> {
  final bool hideAppBar;

  LanguageStartView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideAppBar
          ? null
          : AppBar(
              title: Text(
                "Languages".tr,
                style: context.textTheme.titleLarge,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              // leading: new IconButton(
              //   icon:
              //       new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
              //   onPressed: () => Get.back(),
              // ),
              elevation: 0,
            ),
      body: ListView(
        primary: true,
        children: [
          Obx(() {
            if (Get.find<LaravelApiClient>()
                .isLoading(task: 'getTranslations')) {
              return LanguagesLoaderWidget();
            }
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children:
                    List.generate(TranslationService.languages.length, (index) {
                  var _lang = TranslationService.languages.elementAt(index);
                  return RadioListTile(
                    value: _lang,
                    groupValue: Get.locale.toString(),
                    activeColor: Get.theme.colorScheme.secondary,
                    onChanged: (value) {
                      controller.updateLocale(value);
                    },
                    title: Text(langString(_lang).tr,
                        style: Get.textTheme.bodyMedium),
                  );
                }).toList(),
              ),
            );
          })
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: Get.width,
                child: BlockButtonWidget(
                  onPressed: () {
                    // controller.registerprovider();
                    Get.offAllNamed(Routes.LOGIN);
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
        ],
      ),
    );
  }
}

String langString(String lang) {
  switch (lang) {
    case "en":
      return "English";
    case "pt":
      return "Hinglish";
    case "hi":
      return "Hindi";
  }
  return "";
}
