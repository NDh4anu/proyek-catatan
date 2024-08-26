import 'package:catatan/models/akun.dart';
import 'package:catatan/models/catatan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Akun akun;
  final Catatan catatan;
  const ListItem({
    super.key,
    required this.akun,
    required this.catatan,
  });

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    void deleteCatatan() async {
      try {
        await db.collection('catatan').doc(catatan.docId).delete();
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catatan berhasil dihapus')));
      } catch (e) {
        final snackbar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: const Icon(Icons.note, color: Colors.blue, size: 40),
        title: Text(
          catatan.judul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Kategori: ${catatan.kategori}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Tanggal: ${catatan.tanggal.day}/${catatan.tanggal.month}/${catatan.tanggal.year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () {
          Navigator.pushNamed(context, '/detail',
              arguments: {'catatan': catatan, 'akun': akun});
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  title: Text('Delete ${catatan.judul}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(buildContext);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteCatatan();
                        Navigator.pop(buildContext);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}