
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/local_strings.dart';
import 'package:archiz_cxm360/core/utils/method.dart';
import 'package:archiz_cxm360/core/utils/url_container.dart';
import 'package:archiz_cxm360/common/models/response_model.dart';
import 'package:flutter/foundation.dart';

class AuthRepo {
  ApiClient apiClient;

  AuthRepo({required this.apiClient});

  Future<ResponseModel> loginUser(String email, String password) async {
    Map<String, String> map = {'email': email, 'password': password};
    String url = '${UrlContainer.baseUrl}${UrlContainer.loginUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> updateToken() async {
    String? deviceToken = '@';

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = (await getDeviceToken())!;
      }
    } else {
      deviceToken = (await getDeviceToken())!;
      print("dedv12 $deviceToken");
    }

    FirebaseMessaging.instance.subscribeToTopic(LocalStrings.topic);

    Map<String, String> map = {'fcm_token': deviceToken};
    String url = '${UrlContainer.baseUrl}${UrlContainer.tokenUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);

    return responseModel;
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (error) {
      debugPrint('====> Device Token Error: $error');
    }
    if (deviceToken != null) {
      debugPrint('====> Device Token: $deviceToken');
    }

    return deviceToken;
  }

  Future<ResponseModel> forgetPassword(String email) async {
    Map<String, String> map = {'email': email};
    String url = '${UrlContainer.baseUrl}${UrlContainer.forgotPasswordUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }
}
