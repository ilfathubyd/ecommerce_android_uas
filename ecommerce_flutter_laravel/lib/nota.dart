import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotaPage extends StatelessWidget {
  final String kotaAsal;
  final String kotaTujuan;
  final String kurir;
  final int ongkir;
  final int subtotal;
  final int total;

  NotaPage({
    super.key,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.kurir,
    required this.ongkir,
    required this.subtotal,
    required this.total,
  });

  final _rupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Nota Pesanan'),
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
    ),
    backgroundColor: Colors.grey.shade200,
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionCard(
          title: 'Detail Pengiriman',
          children: [
            _tile(Icons.location_city, 'Kota Asal', kotaAsal),
            _tile(Icons.flag, 'Kota Tujuan', kotaTujuan),
            _tile(Icons.local_shipping, 'Kurir', kurir),
          ],
        ),
        _sectionCard(
          title: 'Ringkasan Biaya',
          children: [
            _priceRow('Subtotal Produk', subtotal),
            const Divider(),
            _priceRow('Ongkir', ongkir),
            const Divider(),
            _priceRow('Total Pembayaran', total, bold: true, orange: true),
          ],
        ),
        // ganti Widget tombol di bagian bawah ListView:
        const SizedBox(height: 20),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
          child: Ink(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B3D), Color(0xFFFF8F1F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );

  // ────────── HELPERS UI
  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    ),
  );

  Widget _tile(IconData icon, String label, String value) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: Colors.deepOrange),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(value.isNotEmpty ? value : '—'),
  );

  Widget _priceRow(
    String label,
    int amount, {
    bool bold = false,
    bool orange = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
        ),
        Text(
          _rupiah.format(amount),
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
            color: orange ? Colors.deepOrange : null,
          ),
        ),
      ],
    ),
  );
}
