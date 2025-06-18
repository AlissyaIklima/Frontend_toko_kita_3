import 'dart:convert';
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/helpers/api.dart';
import 'package:toko_kita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    final api = Api();
    final apiUrl = ApiUrl.registrasi;

    try {
      final response = await api.post(apiUrl, {
        'nama': nama,
        'email': email,
        'password': password,
        'konfirmasi_password': password, // ✅ HARUS ADA! sesuai backend
      }, useToken: false);

      final jsonObj = jsonDecode(response.body);

      if (jsonObj['status'] == true) {
        return Registrasi.fromJson(jsonObj);
      } else {
        throw Exception(jsonObj['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      print('Registrasi Error: $e');
      rethrow;
    }
  }
}
