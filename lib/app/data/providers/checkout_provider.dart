import 'package:litera/app/core/network/api_client.dart';

class CheckoutProvider {
  final ApiClient apiClient = ApiClient();

 Future<dynamic> postCheckout() async {
    final response = await apiClient.post('/checkout');
    return response.data;
  }
}