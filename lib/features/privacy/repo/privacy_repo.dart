import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/method.dart';
import 'package:archiz_cxm360/core/utils/url_container.dart';

class PrivacyRepo {
  ApiClient apiClient;
  PrivacyRepo({required this.apiClient});

  Future<dynamic> loadPrivacyPolicyData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.privacyPolicyUrl}';
    final response = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return response;
  }
}
