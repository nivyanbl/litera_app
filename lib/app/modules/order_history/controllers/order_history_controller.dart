import 'package:get/get.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/repositories/order_repository.dart';

class OrderHistoryController extends GetxController {
  final OrderRepository repository;

  OrderHistoryController({required this.repository});

  var isLoading = true.obs;
  var allOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      final orders = await repository.getOrders();
      allOrders.assignAll(orders);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<OrderModel> get completedOrders =>
      allOrders.where((order) => order.status == 'paid').toList();
}
