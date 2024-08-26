class Catatan {
  final String uid;
  final String docId;
  final String judul;
  final String kategori;
  String? deskripsi;
  final DateTime tanggal;

  Catatan({
    required this.uid,
    required this.docId,
    required this.judul,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
  });
}
