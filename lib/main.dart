import 'package:catatan/firebase_options.dart';
import 'package:catatan/pages/add_catatan_page.dart';
import 'package:catatan/pages/dashboard/dashboard_page.dart';
import 'package:catatan/pages/detail_page.dart';
import 'package:catatan/pages/login_page.dart';
import 'package:catatan/pages/register_page.dart';
import 'package:catatan/pages/update_catatan_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Pencatatan',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
      '/addCatatan': (context) => const AddCatatanPage(),
      '/detail': (context) => const DetailPage(),
      '/update' : (context) => const UpdateCatatanPage(),
    },
  ));
}
