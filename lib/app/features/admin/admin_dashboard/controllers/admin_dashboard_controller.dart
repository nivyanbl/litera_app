import 'package:get/get.dart';
import 'package:litera/app/data/models/admin_dashboard_model.dart';
import 'package:litera/app/data/repositories/admin_dashboard_repository.dart';

class AdminDashboardController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────────
  final AdminDashboardRepository _repository;

  // ─── State ──────────────────────────────────────────────────────────────────
  final RxInt selectedDays = 7.obs;
  final Rx<DashboardModel?> dashboardData = Rx<DashboardModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Derived chart data ──────────────────────────────────────────────────────
  final RxList<String> chartLabels = <String>[].obs;
  final RxDouble chartMaxY = 100000.0.obs;

  // ─── Constructor ─────────────────────────────────────────────────────────────
  AdminDashboardController({required AdminDashboardRepository repository})
    : _repository = repository;

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // ─── Public API ──────────────────────────────────────────────────────────────
  void onPeriodChanged(int days) {
    if (selectedDays.value == days) return;
    selectedDays.value = days;
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final model = await _repository.getDashboard(days: selectedDays.value);
      dashboardData.value = model;
      _buildChartData(model.chartData);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      dashboardData.value = null;
      chartLabels.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  void _buildChartData(List<ChartDataModel> data) {
    if (data.isEmpty) {
      chartLabels.clear();
      chartMaxY.value = 100000;
      return;
    }

    final labels = <String>[];
    double maxRevenue = 0;

    for (int i = 0; i < data.length; i++) {
      final revenue = data[i].revenue;
      labels.add(data[i].label);
      if (revenue > maxRevenue) maxRevenue = revenue;
    }

    chartLabels.value = labels;

    // Add 20% headroom above the tallest bar dynamically from backend data
    chartMaxY.value = maxRevenue > 0 ? maxRevenue * 1.2 : 100000.0;
  }

  String get formattedRevenue {
    final revenue = dashboardData.value?.totalRevenue ?? 0;
    return _formatCurrency(revenue);
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = formatted.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) buffer.write('.');
      buffer.write(formatted[i]);
      counter++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  /// Used by chart to format Y-axis labels (shortened)
  String formatYLabel(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}jt';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}rb';
    return value.toStringAsFixed(0);
  }
}
