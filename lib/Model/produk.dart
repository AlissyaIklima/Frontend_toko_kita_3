class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: int.tryParse(json['id'].toString()),
      kodeProduk: json['kode_produk'],
      namaProduk: json['nama_produk'],
      hargaProduk: int.tryParse(json['harga'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_produk": kodeProduk,
        "nama_produk": namaProduk,
        "harga": hargaProduk,
      };
}
