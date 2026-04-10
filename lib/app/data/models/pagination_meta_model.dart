class PaginationMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;

  PaginationMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMorePages,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}

class AdminOrdersResponseModel {
  final List<dynamic> orders; // Akan di-parse jadi OrderModel di controller
  final PaginationMetaModel meta;

  AdminOrdersResponseModel({
    required this.orders,
    required this.meta,
  });

  factory AdminOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminOrdersResponseModel(
      orders: json['data'] ?? [],
      meta: PaginationMetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}
