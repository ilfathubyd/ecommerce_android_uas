import 'package:ecommerce_flutter_laravel/add_product_page.dart';
import 'package:ecommerce_flutter_laravel/edit_main_page.dart';
import 'package:ecommerce_flutter_laravel/home_pageBACKUP.dart';
import 'package:ecommerce_flutter_laravel/profileADMIN.dart';
import 'package:flutter/material.dart';

class ButtomNavigationBar extends StatefulWidget {
  const ButtomNavigationBar({super.key});

  @override
  State<ButtomNavigationBar> createState() => _ButtomNavigationBarState();
}

class _ButtomNavigationBarState extends State<ButtomNavigationBar> {
  int _selectedIndex = 0;

  // ── daftar halaman ──────────────────────────────────────────────────────
  final List<Widget> _screenList = const [
    HomePage(),
    AddProductPage(),
    EditMainPage(),
    ProfileAdminPage(),
  ];

  // judul AppBar sesuai indeks
  // final List<String> _titles = const [
  //   'Home',
  //   'Tambah Produk',
  //   'Kelola Produk',
  //   'Profil Admin',
  // ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrange,   // seluruh layar di belakang konten
      // ganti body sesuai tab
      body: _screenList[_selectedIndex],

      // ── BottomNav ───────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // ── warna ───────────────────────────────────
        backgroundColor: Colors.deepOrange, // latar belakang nav bar
        selectedItemColor: Colors.white, // ikon & teks saat aktif
        unselectedItemColor: Colors.white70, // ikon & teks saat pasif

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
