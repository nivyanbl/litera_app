import 'package:get/get.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/repositories/order_repository.dart';

class AdminOrdersController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────────
  final OrderRepository _repository;

  // ─── State: Orders List ──────────────────────────────────────────────────────
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  // ─── State: Pagination ──────────────────────────────────────────────────────
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt total = 0.obs;

  static const int _perPage = 10;

  // ─── State: Loading States ──────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Constructor ─────────────────────────────────────────────────────────────
  AdminOrdersController({required OrderRepository repository})
      : _repository = repository;

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadOrdersPage(1);
  }

  // ─── Public API ──────────────────────────────────────────────────────────────

  /// Load orders for specific page
  Future<void> loadOrdersPage(int page) async {
    isLoading.value = true;
    errorMessage.value = '';
    orders.clear();

    try {
      final result = await _repository.getAdminOrdersPaginated(
        page: page,
        perPage: _perPage,
      );

      orders.value = result.orders;
      currentPage.value = result.meta.currentPage;
      lastPage.value = result.meta.lastPage;
      total.value = result.meta.total;

      // Sort by created_at descending (newest first)
      orders.sort((a, b) {
        final dateA = a.createdAtDateTime ?? DateTime(2000);
        final dateB = b.createdAtDateTime ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      errorMessage.value = 'Gagal memuat pesanan. Cek koneksi Anda.';
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Go to next page
  Future<void> nextPage() async {
    if (currentPage.value < lastPage.value) {
      await loadOrdersPage(currentPage.value + 1);
    }
  }

  /// Go to previous page
  Future<void> prevPage() async {
    if (currentPage.value > 1) {
      await loadOrdersPage(currentPage.value - 1);
    }
  }

  /// Go to specific page
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= lastPage.value) {
      await loadOrdersPage(page);
    }
  }

  /// Refresh orders (reload current page)
  Future<void> refreshOrders() async {
    return loadOrdersPage(currentPage.value);
  }

  // ─── Helpers: UI State Getters ───────────────────────────────────────────────
  bool get isEmpty => orders.isEmpty && !isLoading.value;
  bool get hasError => errorMessage.value.isNotEmpty;
  bool get hasOrders => orders.isNotEmpty;
  bool get canPrevious => currentPage.value > 1;
  bool get canNext => currentPage.value < lastPage.value;

  String get progressText {
    if (total.value == 0) return '';
    final start = (currentPage.value - 1) * _perPage + 1;
    final end = (start + orders.length - 1).clamp(0, total.value);
    return 'Menampilkan $start-$end dari ${total.value} pesanan';
  }

  List<int> get pageNumbers {
    final pages = <int>[];
    for (int i = 1; i <= lastPage.value; i++) {
      pages.add(i);
    }
    return pages;
  }

  // ─── Helper: Currency Formatter ──────────────────────────────────────────────
  String formatCurrency(String? price) {
    try {
      final amount = num.tryParse(price ?? '0')?.toInt() ?? 0;
      if (amount == 0) return 'Rp 0';

      final formatted = amount.toString();
      final buffer = StringBuffer();

      for (int i = 0; i < formatted.length; i++) {
        if (i > 0 && (formatted.length - i) % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(formatted[i]);
      }

      return 'Rp $buffer';
    } catch (e) {
      return 'Rp 0';
    }
  }
}
