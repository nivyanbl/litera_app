import 'package:litera/app/data/models/admin_dashboard_model.dart';
import 'package:litera/app/data/providers/admin_dashboard_provider.dart';

class AdminDashboardRepository {
  final AdminDashboardProvider provider;

  AdminDashboardRepository({required this.provider});

  Future<DashboardModel> getDashboard({required int days}) async {
    try {
      final rawData = await provider.getDashboardData(days: days);
      return DashboardModel.fromJson(rawData);
    } catch (e) {
      throw Exception('Failed to fetch dashboard: ${e.toString()}');
    }
  }
}
