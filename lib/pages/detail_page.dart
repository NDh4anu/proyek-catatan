import 'package:catatan/models/catatan.dart';
import 'package:catatan/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Catatan catatan = arguments['catatan'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  catatan.judul,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.note,
                  color: Colors.blue,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  // Membungkus ListTile dengan Card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: const Text('Tanggal Catatan'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy')
                          .format(catatan.tanggal)
                          .toString(),
                    ),
                    leading: const Icon(Icons.date_range),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  // Membungkus ListTile dengan Card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: const Text('Kategori Catatan'),
                    subtitle: Text(catatan.kategori),
                    leading: const Icon(Icons.category),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Deskripsi Laporan',
                  style: headerStyle(level: 2),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(catatan.deskripsi ?? ''),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, '/update',
                            arguments: {'catatan': catatan});
                      },
                      child: Text(
                        'Edit Catatan Saya',
                        style: headerStyle(level: 3, dark: false),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
