import 'package:get_storage/get_storage.dart';
import '../../core/storage/secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final GetStorage _box = GetStorage();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Cek apakah user sudah login
  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Dapatkan role user
  String? getUserRole() {
    return _box.read<String>('role');
  }

  /// Dapatkan nama user
  String? getUserName() {
    return _box.read<String>('name');
  }

  /// Cek apakah user adalah admin
  Future<bool> isAdmin() async {
    if (!await isLoggedIn()) return false;
    return getUserRole() == 'admin';
  }

  /// Simpan login info
  Future<void> saveLoginInfo(String name, String role) async {
    await _box.write('name', name);
    await _box.write('role', role);
  }

  /// Logout
  Future<void> logout() async {
    await SecureStorage.clear();
    await _box.erase();
  }
}
