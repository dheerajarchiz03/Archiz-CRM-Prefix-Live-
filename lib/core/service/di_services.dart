import 'package:archiz_prefix_crm/core/service/api_service.dart';
import 'package:archiz_prefix_crm/common/controllers/localization_controller.dart';
import 'package:archiz_prefix_crm/common/controllers/theme_controller.dart';
import 'package:archiz_prefix_crm/features/splash/controller/splash_controller.dart';
import 'package:archiz_prefix_crm/features/splash/repo/splash_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences, fenix: true);
  Get.lazyPut(() => ApiClient(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashRepo(apiClient: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(
      apiClient: Get.find(), localizationController: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

  Map<String, Map<String, String>> language = {};
  language['en_US'] = {'': ''};

  return language;
}
