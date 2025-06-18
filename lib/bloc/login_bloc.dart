import 'dart:convert';
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/model/login.dart';
import 'package:toko_kita/helpers/api.dart';

class LoginBloc {
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    final api = Api(); // ✅ pakai class Api
    final apiUrl = ApiUrl.login;

    try {
      final response = await api.post(apiUrl, {
        'email': email,
        'password': password,
      }, useToken: false); // login belum pakai token

      final jsonObj = jsonDecode(response.body);

      if (jsonObj['status'] == true) {
        // Simpan token kalau backend kasih token (opsional)
        return Login.fromJson(jsonObj);
      } else {
        throw Exception(jsonObj['message'] ?? 'Login gagal');
      }
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }
}
