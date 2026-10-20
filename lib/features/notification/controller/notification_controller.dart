import 'dart:convert';

import 'package:archiz_cxm360/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:archiz_cxm360/common/models/response_model.dart';
import 'package:archiz_cxm360/features/notification/model/notifications_model.dart';
import 'package:archiz_cxm360/features/notification/repo/notification_repo.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  bool isLoading = true;
  NotificationsModel notificationsModel = NotificationsModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadNotifications();
    isLoading = false;
    update();
  }

  Future<void> loadNotifications() async {
    ResponseModel responseModel = await notificationRepo.getAllNotifications();
    if (responseModel.status) {
      notificationsModel =
          NotificationsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }
}
