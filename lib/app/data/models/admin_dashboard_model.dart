class AdminDashboardModel {
  int? totalRevenue;
  int? totalOrders;
  int? totalProducts;
  int? totalCustomers;
  List<dynamic>? bestSellers;
  List<Map<String, dynamic>>? chartData;

  AdminDashboardModel({
    this.totalRevenue,
    this.totalOrders,
    this.totalProducts,
    this.totalCustomers,
    this.bestSellers,
    this.chartData,
  });

  AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue'];
    totalOrders = json['total_orders'];
    totalProducts = json['total_products'];
    totalCustomers = json['total_customers'];
    bestSellers = json['best_sellers'] ?? [];

    // Parse chart data if available
    if (json['chart_data'] != null && json['chart_data'] is List) {
      chartData = List<Map<String, dynamic>>.from(
        (json['chart_data'] as List).map(
          (item) => item is Map<String, dynamic> ? item : {},
        ),
      );
    }
  }
}
