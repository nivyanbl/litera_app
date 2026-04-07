import 'package:get/get.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/repositories/order_repository.dart';
import 'package:litera/app/core/services/download_service.dart';

class OrderHistoryController extends GetxController {
  final OrderRepository repository;
  final downloadService = DownloadService.to;

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

  /// Check apakah book/detail sudah diunduh
  bool isDetailDownloaded(String detailId) {
    return downloadService.isDownloaded(detailId);
  }

  /// Get reactive map dari semua unduhan
  RxMap<String, bool> get downloadedBooksMap => downloadService.downloadedBooks;
}
