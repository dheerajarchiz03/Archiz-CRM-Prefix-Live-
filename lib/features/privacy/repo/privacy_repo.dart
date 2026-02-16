import 'package:archiz_prefix_crm/core/service/api_service.dart';
import 'package:archiz_prefix_crm/core/utils/method.dart';
import 'package:archiz_prefix_crm/core/utils/url_container.dart';

class PrivacyRepo {
  ApiClient apiClient;
  PrivacyRepo({required this.apiClient});

  Future<dynamic> loadAboutData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.privacyPolicyUrl}';
    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
