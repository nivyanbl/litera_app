import 'package:litera/app/core/network/api_client.dart';

class CheckoutProvider {
  final ApiClient apiClient = ApiClient();

  Future<dynamic> postCheckout({Map<String, dynamic>? data}) async {
    final response = await apiClient.post('/checkout', data: data);
    return response.data;
  }
}