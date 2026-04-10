import 'package:flutter/foundation.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/models/pagination_meta_model.dart';

class AdminOrdersPagedResult {
  final List<OrderModel> orders;
  final PaginationMetaModel meta;

  AdminOrdersPagedResult({
    required this.orders,
    required this.meta,
  });
}

class OrderProvider {
  final ApiClient apiClient;

  OrderProvider(this.apiClient);

  void _logUnknownPaymentMethod(
    OrderModel order,
    Map<String, dynamic> rawEntry,
  ) {
    if (!kDebugMode || !order.isPaymentMethodUnknown) return;

    debugPrint(
      '[ORDER_API] payment method kosong untuk order=${order.externalId ?? order.id}; '
      'keys=${rawEntry.keys.toList()}',
    );
  }

  void _logOrderDetailCount(OrderModel order, Map<String, dynamic> rawEntry) {
    if (!kDebugMode) return;

    debugPrint(
      '[ORDER_API] order=${order.externalId ?? order.id} detailCount=${order.details?.length ?? 0}; '
      'availableKeys=${rawEntry.keys.toList()}',
    );
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await apiClient.get('/orders');

    if (response.data == null) return [];

    final data = response.data['data'] ?? response.data;

    if (data is! List) return [];

    final orders = <OrderModel>[];
    for (final entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final order = OrderModel.fromJson(entry);
      orders.add(order);
      _logUnknownPaymentMethod(order, entry);
      _logOrderDetailCount(order, entry);
    }

    return orders;
  }

  /// Get paginated admin orders
  Future<AdminOrdersPagedResult> getAdminOrdersPaginated({
    required int page,
    int perPage = 10,
  }) async {
    final response = await apiClient.get(
      '/admin/orders',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    if (response.data == null) {
      return AdminOrdersPagedResult(
        orders: [],
        meta: PaginationMetaModel.fromJson({}),
      );
    }

    // Parse orders
    final data = response.data['data'] ?? [];
    if (data is! List) {
      return AdminOrdersPagedResult(
        orders: [],
        meta: PaginationMetaModel.fromJson(response.data['meta'] ?? {}),
      );
    }

    final orders = <OrderModel>[];
    for (final entry in data) {
      if (entry is! Map<String, dynamic>) continue;

      final order = OrderModel.fromJson(entry);
      orders.add(order);
      _logUnknownPaymentMethod(order, entry);
      _logOrderDetailCount(order, entry);
    }

    // Parse meta
    final meta = PaginationMetaModel.fromJson(response.data['meta'] ?? {});

    return AdminOrdersPagedResult(
      orders: orders,
      meta: meta,
    );
  }
}
