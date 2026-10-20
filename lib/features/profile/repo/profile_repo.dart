import 'dart:convert';

import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/method.dart';
import 'package:archiz_cxm360/core/utils/url_container.dart';
import 'package:archiz_cxm360/common/models/response_model.dart';
import 'package:archiz_cxm360/features/profile/model/profile_update_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProfileRepo {
  ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<StatusModel> updateProfile(
    ProfileUpdateModel profileUpdateModel,
  ) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";

    Map<String, String> params = {
      "firstname": profileUpdateModel.firstName,
      "lastname": profileUpdateModel.lastName,
      "phonenumber": profileUpdateModel.phoneNumber ?? '',
      "facebook": profileUpdateModel.facebook ?? '',
      "linkedin": profileUpdateModel.linkedin ?? '',
      "skype": profileUpdateModel.skype ?? '',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(<String, String>{'Authorization': apiClient.token});
    if (profileUpdateModel.image != null) {
      request.files.add(
        http.MultipartFile(
          'profile_image',
          profileUpdateModel.image!.readAsBytes().asStream(),
          profileUpdateModel.image!.lengthSync(),
          filename: profileUpdateModel.image!.path.split('/').last,
        ),
      );
    }

    request.fields.addAll(params);
    http.StreamedResponse response = await request.send();

    String jsonResponse = await response.stream.bytesToString();
    StatusModel responseModel = StatusModel.fromJson(jsonDecode(jsonResponse));

    if (kDebugMode) {
      print(response.statusCode);
      print(params);
      print(jsonResponse);
      print(url.toString());
    }

    return responseModel;
  }
}
