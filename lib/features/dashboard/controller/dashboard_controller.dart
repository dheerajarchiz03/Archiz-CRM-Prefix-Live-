import 'dart:async';
import 'dart:convert';
import 'package:archiz_cxm360/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:archiz_cxm360/core/helper/shared_preference_helper.dart';
import 'package:archiz_cxm360/core/route/route.dart';
import 'package:archiz_cxm360/common/models/response_model.dart';
import 'package:archiz_cxm360/features/dashboard/model/dashboard_model.dart';
import 'package:archiz_cxm360/features/dashboard/repo/dashboard_repo.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  DashboardRepo dashboardRepo;
  DashboardController({required this.dashboardRepo});

  bool isLoading = true;
  bool logoutLoading = false;
  int currentPageIndex = 0;
  DashboardModel homeModel = DashboardModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadData();
    isLoading = false;
    update();
  }

  Future<dynamic> loadData() async {
    ResponseModel responseModel = await dashboardRepo.getData();
    if (responseModel.status) {
      homeModel =
          DashboardModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> logout() async {
    logoutLoading = true;
    update();

    ResponseModel responseModel = await dashboardRepo.logout();

    if (responseModel.status) {
      await dashboardRepo.apiClient.sharedPreferences
          .setString(SharedPreferenceHelper.accessTokenKey, '');
      await dashboardRepo.apiClient.sharedPreferences
          .setBool(SharedPreferenceHelper.rememberMeKey, false);
      CustomSnackBar.success(successList: [responseModel.message.tr]);
      Get.offAllNamed(RouteHelper.loginScreen);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    logoutLoading = false;
    update();
  }
}
