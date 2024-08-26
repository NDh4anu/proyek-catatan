import 'package:catatan/models/akun.dart';
import 'package:catatan/widgets/input_widget.dart';
import 'package:catatan/widgets/styles.dart';
import 'package:catatan/widgets/validator.dart';
import 'package:catatan/widgets/vars.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCatatanPage extends StatefulWidget {
  const AddCatatanPage({super.key});

  @override
  State<AddCatatanPage> createState() => _AddCatatanPageState();
}

class _AddCatatanPageState extends State<AddCatatanPage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool _isLoading = false;

  String? judul;
  String? kategori;
  String? deskripsi;

  void addCatatan(Akun akun) async {
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference catatanCollection = _db.collection('catatan');
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());
      final id = catatanCollection.doc().id;

      await catatanCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'judul': judul,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'docId': id,
        'tanggal': timestamp,
      }).catchError((e) {
        throw e;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil ditambahkan')));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Akun akun = arguments['akun'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Tambah Catatan', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                            'Judul Catatan',
                            TextFormField(
                                onChanged: (String value) => setState(() {
                                      judul = value;
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Judul catatan"))),
                        InputLayout(
                          'Kategori Catatan',
                          DropdownButtonFormField<String>(
                            decoration:
                                customInputDecoration('Kategori Catatan'),
                            items: kategoriCatatan.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                kategori = selected;
                              });
                            },
                          ),
                        ),
                        InputLayout(
                            "Deskripsi laporan",
                            TextFormField(
                              onChanged: (String value) => setState(() {
                                deskripsi = value;
                              }),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua di sini'),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                addCatatan(akun);
                              },
                              child: Text(
                                'Buat Catatan Saya',
                                style: headerStyle(level: 3, dark: false),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
