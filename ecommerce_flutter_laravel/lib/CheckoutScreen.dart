// lib/checkout.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'nota.dart'; // halaman nota setelah sukses

class Checkout extends StatefulWidget {
  final CheckoutItem item;

  const Checkout({super.key, required this.item});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  // ───────── KONFIGURASI
  final String apiKey = 'IJcY46Jxe026418d994b461axMkPEh7U';
  late final NumberFormat _rupiah;

  // ───────── STATE PRODUK
  late int jumlah;
  late int hargaProduk; // harga satuan (int)

  // ───────── STATE PENGIRIMAN & PEMBAYARAN
  String? asalId, asalNama;
  String? tujuanId, tujuanNama;
  String? selectedKurir;
  int selectedOngkir = 0;
  String estimasi = '';
  String? metodePembayaran;

  // ───────── UTIL KURIR (icon acak)
  final _shippingIcons = const [
    Icons.local_shipping,
    Icons.delivery_dining,
    Icons.airport_shuttle,
    Icons.fire_truck,
    Icons.motorcycle,
  ];
  final _rand = Random();
  IconData _randomShippingIcon() =>
      _shippingIcons[_rand.nextInt(_shippingIcons.length)];

  // ───────── INIT
  @override
  void initState() {
    super.initState();
    _rupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    jumlah = widget.item.qty;
    hargaProduk = widget.item.pricePerPiece;
  }

  // ───────── UI UTAMA
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.orange),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text('Checkout', style: TextStyle(color: Colors.black87)),
    ),
    backgroundColor: Colors.grey.shade200,
    body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 12),
            children: [
              _productCard(),
              const SizedBox(height: 12),
              _cityCard(
                title: 'Kota Asal',
                subtitle: asalNama,
                icon: Icons.location_city,
                onTap: () async {
                  final kota = await _searchCityDialog('Pilih Kota Asal');
                  if (kota != null && mounted) {
                    setState(() {
                      asalId = kota['id'].toString();
                      asalNama = kota['city_name'];
                    });
                  }
                },
              ),
              _cityCard(
                title: 'Kota Tujuan',
                subtitle: tujuanNama,
                icon: Icons.flag,
                onTap: () async {
                  final kota = await _searchCityDialog('Pilih Kota Tujuan');
                  if (kota != null && mounted) {
                    setState(() {
                      tujuanId = kota['id'].toString();
                      tujuanNama = kota['city_name'];
                    });
                  }
                },
              ),
              _ongkirCard(),
              _totalCard(),
              _paymentTile(),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed:
                (metodePembayaran != null && selectedKurir != null)
                    ? _showSuccess
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (metodePembayaran != null && selectedKurir != null)
                      ? Colors.deepOrange
                      : Colors.grey.shade300,
              foregroundColor:
                  (metodePembayaran != null && selectedKurir != null)
                      ? Colors.white
                      : Colors.black38,
            ),
            child: const Text(
              'BUAT PESANAN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );

  /*───────────────────────── WIDGET KARTU PRODUK ─────────────────────────*/
  Widget _productCard() => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Image.network(
            "http://192.168.18.38:8000/storage/product_image/${widget.item.product.image}",
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.broken_image, size: 70),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Variasi: ${widget.item.spec.storage}'),
                const SizedBox(height: 5),
                Text(
                  _rupiah.format(hargaProduk),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed:
                    jumlah > 1
                        ? () => setState(() {
                          jumlah--;
                          widget.item.qty = jumlah;
                        })
                        : null,
              ),
              Text(
                '$jumlah',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed:
                    () => setState(() {
                      jumlah++;
                      widget.item.qty = jumlah;
                    }),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /*───────────────────────── WIDGET PILIH KOTA ─────────────────────────*/
  Widget _cityCard({
    required String title,
    required String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle ?? 'Belum dipilih'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );

  /*───────────────────────── WIDGET ONGKIR ─────────────────────────*/
  Widget _ongkirCard() => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: ListTile(
      leading: const Icon(Icons.local_shipping, color: Colors.deepOrange),
      title: const Text(
        'Layanan Pengiriman',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        selectedKurir != null
            ? '$selectedKurir • ETD: $estimasi hari'
            : 'Belum dihitung',
      ),
      trailing:
          selectedKurir != null
              ? Text(
                _rupiah.format(selectedOngkir),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
              : const Icon(Icons.chevron_right),
      onTap: () {
        if (asalId == null || tujuanId == null) {
          _showSnackBar('Pilih kota asal & tujuan terlebih dahulu');
        } else {
          _hitungOngkir();
        }
      },
    ),
  );

  /*───────────────────────── TOTAL & PEMBAYARAN ─────────────────────────*/
  Widget _totalCard() => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _row('Subtotal Produk', hargaProduk * jumlah),
          _row('Ongkir', selectedOngkir),
          const Divider(),
          _row(
            'Total Bayar',
            (hargaProduk * jumlah) + selectedOngkir,
            bold: true,
            orange: true,
          ),
        ],
      ),
    ),
  );

  Widget _paymentTile() => InkWell(
    onTap: _showMetodePembayaran,
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.attach_money, color: Colors.deepOrange),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    metodePembayaran ?? 'Pilih Metode Pembayaran',
                    style: TextStyle(
                      color:
                          metodePembayaran != null
                              ? Colors.black
                              : Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _row(
    String label,
    int value, {
    bool bold = false,
    bool orange = false,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
      Text(
        _rupiah.format(value),
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : null,
          color: orange ? Colors.deepOrange : null,
        ),
      ),
    ],
  );

  /*───────────────────────── HITUNG ONGKIR ─────────────────────────*/
  Future<void> _hitungOngkir() async {
    try {
      final results = await _calculateOngkir(
        originId: asalId!,
        destinationId: tujuanId!,
        weight: 1000, // contoh: 1 kg
      );
      if (!mounted || results.isEmpty) {
        _showSnackBar('Tidak ada layanan tersedia');
        return;
      }
      final selected = await _showOngkirOptions(results);
      if (selected != null && mounted) {
        setState(() {
          selectedKurir = '${selected['courier']} (${selected['service']})';
          selectedOngkir = selected['cost'];
          estimasi = selected['etd'];
        });
      }
    } catch (e) {
      _showSnackBar('Gagal hitung ongkir: $e');
    }
  }

  /*───────────────────────── MODAL METODE PEMBAYARAN ─────────────────────────*/
  void _showMetodePembayaran() => showModalBottomSheet(
    context: context,
    builder:
        (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _metodeItem('Transfer Bank', Icons.account_balance),
              _metodeItem('COD (Bayar di Tempat)', Icons.money),
              _metodeItem('ShopeePay', Icons.qr_code),
            ],
          ),
        ),
  );

  Widget _metodeItem(String metode, IconData icon) => ListTile(
    leading: Icon(icon, color: Colors.deepOrange),
    title: Text(metode),
    trailing:
        metodePembayaran == metode
            ? const Icon(Icons.check, color: Colors.deepOrange)
            : null,
    onTap: () {
      setState(() => metodePembayaran = metode);
      Navigator.pop(context);
    },
  );

  /*───────────────────────── DIALOG SUKSES & NOTA ─────────────────────────*/
  void _showSuccess() async {
    // tampilkan animasi sukses ±2 dtk
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Success',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, ___, __) {
        if (anim.status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 2), () {
            if (Navigator.canPop(ctx)) Navigator.pop(ctx);
          });
        }
        return Opacity(
          opacity: anim.value,
          child: Transform.scale(
            scale: Tween<double>(begin: 0.8, end: 1).transform(anim.value),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/json/success.json',
                      width: 220,
                      repeat: false,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.check_circle,
                            size: 120,
                            color: Colors.green,
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pesanan berhasil!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // navigasi ke NotaPage
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => NotaPage(
              kotaAsal: asalNama ?? '',
              kotaTujuan: tujuanNama ?? '',
              kurir: selectedKurir ?? '',
              ongkir: selectedOngkir,
              subtotal: hargaProduk * jumlah,
              total: (hargaProduk * jumlah) + selectedOngkir,
            ),
      ),
    );
  }

  /*───────────────────────── CARI KOTA ─────────────────────────*/
  Future<Map<String, dynamic>?> _searchCityDialog(String title) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        List<Map<String, dynamic>> hasil = [];
        final controller = TextEditingController();
        return StatefulBuilder(
          builder: (ctx2, setStateDialog) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Ketik nama kota...',
                    ),
                    onChanged: (q) async {
                      if (q.length < 3) {
                        setStateDialog(() => hasil = []);
                        return;
                      }
                      try {
                        final list = await _searchCity(q);
                        setStateDialog(() => hasil = list);
                      } catch (e) {
                        _showSnackBar('Error: $e');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.maxFinite,
                    height: 250,
                    child:
                        hasil.isEmpty
                            ? const Center(child: Text('Tidak ada data'))
                            : ListView.builder(
                              itemCount: hasil.length,
                              itemBuilder: (_, i) {
                                final k = hasil[i];
                                return ListTile(
                                  title: Text(k['city_name']),
                                  subtitle: Text(
                                    '${k['province']} • ${k['zipcode']}',
                                  ),
                                  onTap: () => Navigator.pop(ctx2, k),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _searchCity(String query) async {
    final uri = Uri.https(
      'rajaongkir.komerce.id',
      '/api/v1/destination/domestic-destination',
      {'search': query, 'limit': '3', 'offset': '0'},
    );
    final res = await http.get(uri, headers: {'key': apiKey});
    if (res.statusCode == 200) {
      final List data = json.decode(res.body)['data'];
      return data
          .map<Map<String, dynamic>>(
            (c) => {
              'id': c['id'],
              'city_name': c['city_name'],
              'province': c['province_name'],
              'zipcode': c['zip_code'],
            },
          )
          .toList();
    }
    if (res.statusCode == 404) return [];
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }

  /*───────────────────────── HITUNG ONGKIR (API) ─────────────────────────*/
  Future<List<Map<String, dynamic>>> _calculateOngkir({
    required String originId,
    required String destinationId,
    required int weight,
  }) async {
    final res = await http.post(
      Uri.parse('https://rajaongkir.komerce.id/api/v1/calculate/domestic-cost'),
      headers: {
        'key': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'origin': originId,
        'destination': destinationId,
        'weight': '$weight',
        'courier': 'jne:jnt:sicepat:anteraja:pos:tiki',
        'price': 'lowest',
      },
    );
    if (res.statusCode == 200) {
      final List data = json.decode(res.body)['data'];
      return data.map<Map<String, dynamic>>((d) {
        // field "courier" bisa Map atau String
        var courierField = d['courier'];
        String courierName;
        if (courierField is Map) {
          courierName = courierField['name'] ?? courierField['code'] ?? '–';
        } else {
          courierName = courierField?.toString() ?? '–';
        }
        return {
          'courier': courierName,
          'service': d['service'],
          'cost': d['cost'],
          'etd': d['etd'],
        };
      }).toList();
    }
    throw Exception('statusCode ${res.statusCode}: ${res.reasonPhrase}');
  }

  Future<Map<String, dynamic>?> _showOngkirOptions(
    List<Map<String, dynamic>> list,
  ) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => DraggableScrollableSheet(
            maxChildSize: 0.85,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            builder:
                (_, controller) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: ListView.builder(
                    controller: controller,
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final k = list[i];
                      return ListTile(
                        leading: Icon(
                          _randomShippingIcon(),
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          '${k['courier']?.toString().toUpperCase() ?? ''} - ${k['service']}',
                        ),
                        subtitle: Text('ETD: ${k['etd']} hari'),
                        trailing: Text(_rupiah.format(k['cost'])),
                        onTap: () => Navigator.pop(ctx, k),
                      );
                    },
                  ),
                ),
          ),
    );
  }

  /*───────────────────────── SNACKBAR UTIL ─────────────────────────*/
  void _showSnackBar(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
