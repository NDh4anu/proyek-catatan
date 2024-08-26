import 'package:catatan/models/akun.dart';
import 'package:catatan/models/catatan.dart';
import 'package:catatan/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatatanPage extends StatefulWidget {
  final Akun akun;
  const CatatanPage({super.key, required this.akun});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  final _db = FirebaseFirestore.instance;

  List<Catatan> listCatatan = [];

  @override
  void initState() {
    super.initState();
    getCatatan();
  }

  void getCatatan() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('catatan')
          .where('uid', isEqualTo: widget.akun.uid)
          .get();

      if (!mounted) return;
      setState(() {
        listCatatan.clear();
        for (var documents in querySnapshot.docs) {
          listCatatan.add(Catatan(
            uid: documents.data()['uid'],
            judul: documents.data()['judul'],
            kategori: documents.data()['kategori'],
            deskripsi: documents.data()['deskripsi'],
            docId: documents.data()['docId'],
            tanggal: documents.data()['tanggal'].toDate(),
          ));
        }
      });
    } catch (e) {
      if (!mounted) return;

      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listCatatan.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada catatan',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listCatatan.length,
              itemBuilder: (context, index) {
                return ListItem(catatan: listCatatan[index], akun: widget.akun);
              },
            ),
    );
  }
}
