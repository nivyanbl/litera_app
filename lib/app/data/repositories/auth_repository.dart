import 'package:get_storage/get_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class AuthRepository {
  final AuthProvider _provider;
  final GetStorage _box;

  AuthRepository(this._provider, this._box);

  Future<UserModel> login(String email, String password) async {
    final user = await _provider.login(email, password);

    await SecureStorage.saveToken(user.token);

    await _box.write('name', user.name);
    await _box.write('role', user.role);

    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final user = await _provider.register(name, email, password);

    await SecureStorage.saveToken(user.token);
    await _box.write('name', user.name);
    await _box.write('role', user.role);

    return user;
  }

  Future<void> logout() async {
    await SecureStorage.clear();
    await _box.erase();
  }
}
