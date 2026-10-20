import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/method.dart';
import 'package:archiz_cxm360/core/utils/url_container.dart';
import 'package:archiz_cxm360/common/models/response_model.dart';

class PaymentRepo {
  ApiClient apiClient;
  PaymentRepo({required this.apiClient});

  Future<ResponseModel> getAllPayments() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.paymentsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getPaymentDetails(paymentId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.paymentsUrl}/id/$paymentId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchPayment(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.paymentsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
