import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/models/admin_dashboard_model.dart';

class AdminDashboardController extends GetxController {
  var isLoading = true.obs;
  var dashboardData = AdminDashboardModel().obs;

  // State Management
  var selectedPeriodIndex = 0.obs;
  var bottomNavIndex = 0.obs;
  var chartSpots = <FlSpot>[].obs;
  var chartLabels = <String>[].obs;
  var chartMaxY = 75.0.obs;

  // Period options
  final periods = ['7 Hari', '30 Hari', '90 Hari'];
  final periodDays = [7, 30, 90];

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    // Auto-refetch when period changes
    ever(selectedPeriodIndex, (_) => _refreshChartData());
  }

  Future<void> fetchDashboardData({int? days}) async {
    try {
      isLoading(true);

      // Use selected period days if not specified
      days ??= periodDays[selectedPeriodIndex.value];

      // Fetch data with period parameter
      final response = await ApiClient().get('/admin/dashboard?days=$days');

      if (response.statusCode == 200) {
        final dashData = AdminDashboardModel.fromJson(response.data['data']);
        dashboardData.value = dashData;

        // Convert chart data if available
        _processChartData(dashData);
      } else {
        Get.snackbar("Info", "Gagal memuat data dashboard");
        _setDefaultChartData();
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan server");
      print("Error Dashboard: $e");
      _setDefaultChartData();
    } finally {
      isLoading(false);
    }
  }

  Future<void> _refreshChartData() async {
    try {
      final days = periodDays[selectedPeriodIndex.value];
      final response = await ApiClient().get('/admin/dashboard?days=$days');

      if (response.statusCode == 200) {
        final dashData = AdminDashboardModel.fromJson(response.data['data']);
        dashboardData.value = dashData;
        _processChartData(dashData);
      } else {
        _setDefaultChartData();
      }
    } catch (e) {
      print("Error refreshing chart: $e");
      _setDefaultChartData();
    }
  }

  /// Process chart data from API response
  void _processChartData(AdminDashboardModel data) {
    // If API provides chartData, use it; otherwise use sample data
    if (data.chartData != null && data.chartData!.isNotEmpty) {
      // Extract labels and map to FlSpots
      final labels = <String>[];
      final spots = <FlSpot>[];

      for (int i = 0; i < data.chartData!.length; i++) {
        final item = data.chartData![i];
        labels.add(item['label']?.toString() ?? 'N/A');
        spots.add(
          FlSpot(i.toDouble(), (item['revenue'] as num?)?.toDouble() ?? 0.0),
        );
      }

      chartLabels.value = labels;
      chartSpots.value = spots;

      // Calculate max Y for chart
      final maxRevenue = spots.isEmpty
          ? 75.0
          : spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
      chartMaxY.value = (maxRevenue * 1.2); // Add 20% padding
    } else {
      // Use default sample data
      _setDefaultChartData();
    }
  }

  /// Set default chart data (sample)
  void _setDefaultChartData() {
    chartLabels.value = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    chartSpots.value = const [
      FlSpot(0, 35),
      FlSpot(1, 42),
      FlSpot(2, 38),
      FlSpot(3, 50),
      FlSpot(4, 55),
      FlSpot(5, 48),
      FlSpot(6, 60),
    ];
    chartMaxY.value = 75.0;
  }

  /// Update period selection
  void selectPeriod(int index) {
    selectedPeriodIndex.value = index;
    // ever() listener will trigger _refreshChartData() automatically
  }

  /// Update bottom nav selection
  void selectBottomNav(int index) {
    bottomNavIndex.value = index;
  }
}
