import 'package:flutter/material.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final _kodeCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _kodeCtrl.text = widget.produk!.kodeProduk ?? '';
      _namaCtrl.text = widget.produk!.namaProduk ?? '';
      _hargaCtrl.text = widget.produk!.hargaProduk.toString();
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    Produk produk = Produk(
      id: widget.produk?.id,
      kodeProduk: _kodeCtrl.text,
      namaProduk: _namaCtrl.text,
      hargaProduk: int.tryParse(_hargaCtrl.text) ?? 0,
    );

    bool success =
        widget.produk == null
            ? await ProdukBloc.addProduk(produk: produk)
            : await ProdukBloc.updateProduk(produk: produk);

    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.produk != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Produk" : "Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textInput("Kode Produk", _kodeCtrl),
              const SizedBox(height: 16),
              _textInput("Nama Produk", _namaCtrl),
              const SizedBox(height: 16),
              _textInput("Harga", _hargaCtrl, inputType: TextInputType.number),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? "Ubah" : "Simpan"),
                  onPressed: _loading ? null : _simpan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Harus diisi" : null,
    );
  }
}
