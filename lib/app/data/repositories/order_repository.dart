import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/providers/order_provider.dart';

class OrderRepository {
  final OrderProvider orderProvider;

  OrderRepository(this.orderProvider);

  Future<List<OrderModel>> getOrders() async {
    return await orderProvider.getOrders();
  }

  Future<AdminOrdersPagedResult> getAdminOrdersPaginated({
    required int page,
    int perPage = 10,
  }) async {
    return await orderProvider.getAdminOrdersPaginated(
      page: page,
      perPage: perPage,
    );
  }
}