import 'package:litera/app/data/models/checkout_rmodel.dart';
import 'package:litera/app/data/providers/checkout_provider.dart';

class CheckoutRepository {
  final CheckoutProvider provider;

  CheckoutRepository(this.provider);

  Future<CheckoutModel> postCheckout() async {
    final response = await provider.postCheckout();
    return CheckoutModel.fromJson(response);
  }
}