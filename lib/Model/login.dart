class Login {
  final int code;
  final bool status;
  final String token;
  final int userID;
  final String userEmail;

  Login({
    required this.code,
    required this.status,
    required this.token,
    required this.userID,
    required this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final user = data['user'] ?? data; // fallback kalau langsung id/email tanpa 'user'

    return Login(
      code: json['code'] ?? 0,
      status: json['status'] ?? false,
      token: data['token'] ?? '',
      userID: int.tryParse(user['id']?.toString() ?? '0') ?? 0,
      userEmail: user['email'] ?? '',
    );
  }
}
