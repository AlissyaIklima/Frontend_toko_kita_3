import 'package:flutter/material.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';
import 'package:toko_kita/bloc/logout_bloc.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/ui/produk_detail.dart';
import 'package:toko_kita/ui/login_page.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> _produkList = [];

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  void _loadProduk() async {
    _produkList = await ProdukBloc.getProduks();
    setState(() {});
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("List Produk"),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            bool? result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProdukForm()),
            );
            if (result == true) _loadProduk();
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await LogoutBloc.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    ),
    body: _produkList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _produkList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              var p = _produkList[i];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(p.namaProduk ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Rp ${p.hargaProduk}", style: const TextStyle(color: Colors.black54)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProdukDetail(produk: p)),
                    );
                    if (result == true) _loadProduk();
                  },
                ),
              );
            },
          ),
  );
}
}
