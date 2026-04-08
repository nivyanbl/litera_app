double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }
  return defaultValue;
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }
  return defaultValue;
}

class DashboardModel {
  final double totalRevenue;
  final List<BestSellerModel> bestSellers;
  final List<MostCartedModel> mostCarted;
  final List<ChartDataModel> chartData;
  final int filterDays;

  DashboardModel({
    required this.totalRevenue,
    required this.bestSellers,
    required this.mostCarted,
    required this.chartData,
    required this.filterDays,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return DashboardModel(
      totalRevenue: _parseDouble(data['total_revenue']),
      bestSellers: (data['best_sellers'] as List<dynamic>? ?? [])
          .map((e) => BestSellerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostCarted: (data['most_carted'] as List<dynamic>? ?? [])
          .map((e) => MostCartedModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      chartData: (data['chart_data'] as List<dynamic>? ?? [])
          .map((e) => ChartDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      filterDays: _parseInt(data['filter_days'], defaultValue: 7),
    );
  }
}

class BestSellerModel {
  final int productId;
  final int totalSold;
  final ProductModel product;

  BestSellerModel({
    required this.productId,
    required this.totalSold,
    required this.product,
  });

  factory BestSellerModel.fromJson(Map<String, dynamic> json) {
    return BestSellerModel(
      productId: _parseInt(json['product_id']),
      totalSold: _parseInt(json['total_sold']),
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class MostCartedModel {
  final int productId;
  final int totalInCart;
  final ProductModel product;

  MostCartedModel({
    required this.productId,
    required this.totalInCart,
    required this.product,
  });

  factory MostCartedModel.fromJson(Map<String, dynamic> json) {
    return MostCartedModel(
      productId: _parseInt(json['product_id']),
      totalInCart: _parseInt(json['total_in_cart']),
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ProductModel {
  final int id;
  final String title;
  final String image;

  ProductModel({required this.id, required this.title, required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _parseInt(json['id']),
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class ChartDataModel {
  final String label;
  final double revenue;

  ChartDataModel({required this.label, required this.revenue});

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      label: json['label'] as String? ?? '',
      revenue: _parseDouble(json['revenue']),
    );
  }
}
