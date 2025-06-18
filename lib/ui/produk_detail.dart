import 'package:flutter/material.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';

class ProdukDetail extends StatelessWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Detail Produk")),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Kode", produk.kodeProduk ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow("Nama", produk.namaProduk ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow("Harga", "Rp ${produk.hargaProduk}"),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProdukForm(produk: produk)),
                    );
                    if (result == true) Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => _hapus(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Hapus"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Row(
    children: [
      Text(
        "$label: ",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Expanded(
        child: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    ],
  );
}


  void _hapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Hapus"),
            onPressed: () async {
              Navigator.pop(context);
              bool success = await ProdukBloc.deleteProduk(id: produk.id);
              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gagal menghapus")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
