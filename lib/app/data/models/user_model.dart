class UserModel {
  final String token;
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String birthDate;
  late final String profilePicture;
  final String role;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.birthDate,
    required this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] is Map<String, dynamic>
        ? json['data']
        : json;
    final Map<String, dynamic> user = data['user'] is Map<String, dynamic>
        ? data['user']
        : data;
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
      phoneNumber: (user['phone_number'] ?? '').toString(),
      birthDate: (user['birth_date'] ?? '').toString(),
      profilePicture: (user['profile_picture'] ?? '').toString(),
    );
  }
}
