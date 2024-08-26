import 'package:shared_preferences/shared_preferences.dart';
import 'package:catatan/widgets/input_widget.dart';
import 'package:catatan/widgets/styles.dart';
import 'package:catatan/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? email;
  String? password;

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

      String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        await saveToken(token);
      }

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', ModalRoute.withName('/dashboard'));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login berhasil')));
    } catch (e) {
      const snackbar = SnackBar(content: Text('Kata Sandi atau Email Salah'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    if (token != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', ModalRoute.withName('/dashboard'));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text('Login', style: headerStyle(level: 1)),
                    Container(
                      child: const Text(
                        'Login to your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputLayout(
                                  'Email',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            email = value;
                                          }),
                                      validator: notEmptyValidator,
                                      decoration: customInputDecoration(
                                          "email@email.com"))),
                              InputLayout(
                                  'Password',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            password = value;
                                          }),
                                      validator: notEmptyValidator,
                                      obscureText: !_isPasswordVisible,
                                      decoration:
                                          customInputDecoration("Password",
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              )))),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: FilledButton(
                                    style: buttonStyle,
                                    child: Text('Login',
                                        style:
                                            headerStyle(level: 3, dark: false)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        login();
                                      }
                                    }),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/register', (Route<dynamic> route) => false);
                          },
                          child: const Text('Daftar di sini',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
