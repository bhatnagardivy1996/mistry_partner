import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';

class BookingsEmptyListWidget extends StatelessWidget {
  BookingsEmptyListWidget({
    Key key,
  }) : super(key: key);
  final authService = Get.find<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(25),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.grey.withOpacity(0.6),
                        Colors.grey.withOpacity(0.2),
                      ])),
              child: Icon(
                Icons.assignment_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 50,
              ),
            ),
            Opacity(
              opacity: 0.3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  " You don’t have any booking requests yet."
                      .tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              // width: Get.width,
              child: BlockButtonWidget(
                onPressed: () async {
                  Get.toNamed(Routes.PROFILE);
                },
                color: Colors.orange,
                text: Text(
                  "Update Profile".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6
                      .merge(TextStyle(color: Get.theme.colorScheme.onPrimary)),
                ),
              ).paddingOnly(top: 15, bottom: 5, right: 15, left: 15),
            ),
            Expanded(
              // width: Get.width,
              child: BlockButtonWidget(
                onPressed: () async {
                  Get.offAndToNamed(Routes.E_SERVICE_FORM,
                      arguments: {'eService': EService(), 'isbook': true});
                },
                color: Colors.orange,
                text: Text(
                  "Select Service".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6
                      .merge(TextStyle(color: Get.theme.colorScheme.onPrimary)),
                ),
              ).paddingOnly(top: 15, bottom: 5, right: 15, left: 15),
            ),
            Expanded(
              // width: Get.width,
              child: BlockButtonWidget(
                onPressed: () async {
                  // controller.registerprovider();
                  // Get.offAllNamed(Routes.PHONE_VERIFICATION);
                  await Get.offAllNamed(Routes.PROVIDER_REGISTRATION,
                      arguments: {'isbook': true, 'isregister': false});
                },
                color: Colors.orange,
                text: Text(
                  "KYC Update".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6
                      .merge(TextStyle(color: Get.theme.colorScheme.onPrimary)),
                ),
              ).paddingOnly(top: 15, bottom: 5, right: 15, left: 15),
            ),
          ],
        ),
      ],
    );
  }
}
