import 'dart:convert';
import 'package:toko_kita/helpers/api.dart';
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    final response = await Api().get(ApiUrl.listProduk);
    final jsonObj = json.decode(response.body);
    List list = jsonObj['data'];
    return list.map((e) => Produk.fromJson(e)).toList();
  }

  static Future<bool> addProduk({Produk? produk}) async {
    final body = produk!.toJson();
    final response = await Api().post(ApiUrl.createProduk, body);
    final jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

 static Future<bool> updateProduk({required Produk produk}) async {
  final body = produk.toJson();
  print("Update body: $body");
  final response = await Api().put(ApiUrl.updateProduk(produk.id!), body);
  print("Update response: ${response.body}");
  final jsonObj = json.decode(response.body);
  return jsonObj['status']; // apakah ini true?
}

  static Future<bool> deleteProduk({int? id}) async {
    final response = await Api().delete(ApiUrl.deleteProduk(id!));
    final jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }
}
