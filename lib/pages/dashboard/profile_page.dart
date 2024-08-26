import 'package:catatan/models/akun.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Akun akun;
  const ProfilePage({super.key, required this.akun});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  Future<void> logout() async {
    await _auth.signOut();
    await clearToken();
    Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Logout berhasil')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                color: Colors.blue,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.akun.nama,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            const SizedBox(height: 10),
            Text(
              widget.akun.noHp,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              widget.akun.email,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
            const SizedBox(height: 40),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: const Icon(Icons.logout, color: Colors.blue, size: 30),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Apakah Anda yakin ingin logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(buildContext);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              logout();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
