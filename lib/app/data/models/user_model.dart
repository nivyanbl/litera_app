class UserModel {
  final String token;
  final int id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ) ?? {};
    final user = (data['user'] as Map<String, dynamic>? ) ?? {};

    final dynamic rawId = user['id'];
    final int parsedId = rawId is int
        ? rawId
        : rawId is num
            ? rawId.toInt()
            : int.tryParse(rawId?.toString() ?? '') ?? 0;

    return UserModel(
      token: (data['token'] ?? '').toString(),
      id: parsedId,
      name: (user['name'] ?? '').toString(),
      email: (user['email'] ?? '').toString(),
      role: (user['role'] ?? '').toString(),
    );
  }
}
