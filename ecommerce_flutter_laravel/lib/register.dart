import 'package:ecommerce_flutter_laravel/login.dart';
import 'package:ecommerce_flutter_laravel/widget/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  // controller
  final _namaCtrl = TextEditingController();
  final _nomorCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // toggle password visibility
  bool _obscure = true;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nomorCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  //───────────────────────────────────────────────────────────────────────────
  // helper – kumpulkan kolom yang kosong → untuk SnackBar
  List<String> _emptyFields() {
    final fields = <String, TextEditingController>{
      'Nama Lengkap': _namaCtrl,
      'Nomor Telepon': _nomorCtrl,
      'Email': _emailCtrl,
      'Username': _usernameCtrl,
      'Password': _passwordCtrl,
    };
    return fields.entries
        .where((e) => e.value.text.trim().isEmpty)
        .map((e) => e.key)
        .toList();
  }

  //───────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 8),
                Text(
                  'Hai, Selamat datang.',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.deepOrange,
                  ),
                ),
                Text(
                  'Java\'s Store',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // ── FIELD ───────────────────────────────────────────────
                textFieldCustom(
                  'Nama Lengkap',
                  _namaCtrl,
                  hintText: 'ex : John Doe',
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                textFieldCustom(
                  'Nomor Telepon',
                  _nomorCtrl,
                  hintText: 'ex : 08123456789',
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                textFieldCustom(
                  'Email',
                  _emailCtrl,
                  hintText: 'ex : example@gmail.com',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-]+$');
                    return regex.hasMatch(v.trim())
                        ? null
                        : 'Format email tidak valid';
                  },
                ),
                textFieldCustom(
                  'Username',
                  _usernameCtrl,
                  hintText: 'ex : johndoe99',
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                textFieldCustom(
                  'Password',
                  _passwordCtrl,
                  hintText: 'Minimal 6 karakter',
                  isPassword: true,
                  obscureText: _obscure,
                  toggleVisibility: () => setState(() => _obscure = !_obscure),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                    if (v.trim().length < 6) return 'Min. 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // ── TOMBOL DAFTAR ──────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      // tampilkan pesan jika ada kolom kosong
                      final empty = _emptyFields();
                      if (empty.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Kolom berikut wajib diisi: ${empty.join(', ')}',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }

                      // validasi form
                      if (_formKey.currentState!.validate()) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs
                          ..setString('nama', _namaCtrl.text.trim())
                          ..setString('nomor', _nomorCtrl.text.trim())
                          ..setString('email', _emailCtrl.text.trim())
                          ..setString('username', _usernameCtrl.text.trim())
                          ..setString('password', _passwordCtrl.text);

                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    },
                    child: Text(
                      'DAFTAR',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                // ── TOMBOL LOGIN ───────────────────────────────────────
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                      side: const BorderSide(
                        color: Colors.deepOrange,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                    child: Text(
                      'LOGIN',
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
