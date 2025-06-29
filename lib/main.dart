import 'package:flutter/material.dart';
import 'package:toko_kita/UI/produk_page.dart';
import 'package:toko_kita/UI/login_page.dart';
import 'package:toko_kita/helpers/user_info.dart';
import 'dart:io';

void main() {
  // Tambahkan ini untuk debug HTTP
  HttpClient client = HttpClient();
  client.findProxy = (uri) => "PROXY 10.0.2.2:8080";
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override  
  void initState(){
    super.initState();
    isLogin();
  }
  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page =  ProdukPage();
      });
    } else {
      setState(() {
        page = LoginPage();
      });
    }
  }

  @override  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}