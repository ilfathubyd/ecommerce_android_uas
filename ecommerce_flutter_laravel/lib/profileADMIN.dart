import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';



class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {

  
  // ── data profil & statistik ────────────────────────────────────────────────
  String _adminName = 'Admin';
  String _adminEmail = '-';
  int _totalProduk = 0;
  int _totalPesanan = 0;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminName = prefs.getString('adminName') ?? 'Admin';
      _adminEmail = prefs.getString('adminEmail') ?? '-';
      _totalProduk = prefs.getInt('totalProduk') ?? 0;
      _totalPesanan = prefs.getInt('totalPesanan') ?? 0;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // HEADER ───────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/admin.png'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  _adminName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _adminEmail,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STATISTIK ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _statCard(
                  icon: Icons.inventory_2,
                  label: 'Produk',
                  value: _totalProduk,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                _statCard(
                  icon: Icons.shopping_bag,
                  label: 'Pesanan',
                  value: _totalPesanan,
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ACTION LIST ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _actionTile(
                    icon: Icons.inventory_2,
                    title: 'Kelola Produk',
                    onTap: navigateToProduk,
                  ),
                  const Divider(height: 0),
                  _actionTile(
                    icon: Icons.shopping_bag,
                    title: 'Kelola Pesanan',
                    onTap: navigateToPesanan,
                  ),
                  const Divider(height: 0),
                  _actionTile(
                    icon: Icons.settings,
                    title: 'Pengaturan',
                    onTap: navigateToPengaturan,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // LOGOUT ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── WIDGET BANTUAN ────────────────────────────────────────────────────────
  Widget _statCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.black12.withOpacity(0.07),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // ── NAVIGASI (ganti sesuai kebutuhan) ────────────────────────────────────
  void navigateToProduk() {
    // TODO: pindah ke halaman manajemen produk
  }

  void navigateToPesanan() {
    // TODO: pindah ke halaman manajemen pesanan
  }

  void navigateToPengaturan() {
    // TODO: pindah ke halaman pengaturan admin
  }
}
