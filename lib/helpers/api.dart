import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:toko_kita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(String url, dynamic data, {bool useToken = true}) async {
    String? token = useToken ? await UserInfo().getToken() : null;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          if (useToken && token != null)
            HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> get(String url) async {
    String? token = await UserInfo().getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> delete(String url) async {
    String? token = await UserInfo().getToken();

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> put(String url, dynamic data, {bool useToken = true}) async {
  String? token = useToken ? await UserInfo().getToken() : null;

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          if (useToken && token != null)
            HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }


  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error while communicating with server. StatusCode: ${response.statusCode}');
    }
  }
}
