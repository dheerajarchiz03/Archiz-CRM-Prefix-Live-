import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:archiz_cxm360/core/service/notification_service.dart';
import 'package:archiz_cxm360/core/utils/local_strings.dart';
import 'package:archiz_cxm360/core/utils/themes.dart';
import 'package:archiz_cxm360/common/controllers/localization_controller.dart';
import 'package:archiz_cxm360/common/controllers/theme_controller.dart';
import 'package:archiz_cxm360/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:archiz_cxm360/core/route/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/service/di_services.dart' as services;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel? channel;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (defaultTargetPlatform == TargetPlatform.android) {
    FirebaseMessaging.instance.requestPermission();
  }
  String? typeID;
  try {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      typeID = remoteMessage.notification!.titleLocKey;
    }
    await NotificationService.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    debugPrint('====> Notification Error: ${e.toString()}');
  }
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Map<String, Map<String, String>> languages = await services.init();

  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(typeID: typeID, languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final String? typeID;
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.typeID, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (theme) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetMaterialApp(
          title: LocalStrings.appName.tr,
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
          initialRoute: RouteHelper.splashScreen,
          navigatorKey: Get.key,
          theme: theme.darkTheme ? dark : light,
          getPages: RouteHelper().routes,
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(localizeController.locale.languageCode,
              localizeController.locale.countryCode),
        );
      });
    });
  }
}
