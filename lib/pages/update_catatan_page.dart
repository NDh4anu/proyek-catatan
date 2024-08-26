import 'package:catatan/models/catatan.dart';
import 'package:catatan/widgets/input_widget.dart';
import 'package:catatan/widgets/styles.dart';
import 'package:catatan/widgets/validator.dart';
import 'package:catatan/widgets/vars.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCatatanPage extends StatefulWidget {
  const UpdateCatatanPage({super.key});

  @override
  State<UpdateCatatanPage> createState() => _UpdateCatatanPageState();
}

class _UpdateCatatanPageState extends State<UpdateCatatanPage> {
  final _db = FirebaseFirestore.instance;

  bool _isLoading = false;

  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  String? kategori;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _deskripsiController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final Catatan catatan = arguments['catatan'];

      setState(() {
        _judulController.text = catatan.judul;
        _deskripsiController.text = catatan.deskripsi ?? '';
        kategori = catatan.kategori;
      });
    });
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void updateCatatan(Catatan catatan) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _db.collection('catatan').doc(catatan.docId).update({
        'judul': _judulController.text,
        'kategori': kategori,
        'deskripsi': _deskripsiController.text,
        'tanggal': Timestamp.now(),
      }).catchError((e) {
        throw e;
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil diperbarui')));
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
    final Catatan catatan = arguments['catatan'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Update Catatan', style: headerStyle(level: 3, dark: false)),
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
                                controller: _judulController,
                                onChanged: (String value) => setState(() {
                                      // Judul diperbarui melalui controller
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Judul catatan"))),
                        InputLayout(
                          'Kategori Catatan',
                          DropdownButtonFormField<String>(
                            value: kategori,
                            decoration:
                                customInputDecoration('Kategori Catatan'),
                            items: kategoriCatatan.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
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
                              controller: _deskripsiController,
                              onChanged: (String value) => setState(() {}),
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
                                updateCatatan(catatan);
                              },
                              child: Text(
                                'Update Catatan Saya',
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
