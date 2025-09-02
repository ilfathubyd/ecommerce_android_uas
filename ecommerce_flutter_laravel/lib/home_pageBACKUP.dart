import 'package:ecommerce_flutter_laravel/API/ProductService.dart';
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:flutter/material.dart';
import 'detail_product_pageBACKUP.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Perhitungan kolom grid responsif
  int getCrossAxisCount(double width) {
    if (width < 600) {
      return 2; // smartphone
    } else if (width < 900) {
      return 4; // tablet kecil
    } else {
      return 5; // tablet besar / desktop
    }
  }

  late Future<List<Product>> _futureProduct; // Future
  List<Product> _products = []; // Data siap pakai

  @override
  void initState() {
    super.initState();
    _futureProduct = Productservice().getProduct();
    _futureProduct.then((value) {
      setState(() => _products = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // ───────────────────────── Scaffold saja, TANPA MaterialApp ─────────────────────────
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          "Java's Store",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ───────────── Hero Section ─────────────
            Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Welcome To Our Store",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: screenWidth * 0.5,
                  child: Image.asset(
                    "assets/images/redmi-note-14-series.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            // ───────────── Main Section (Grid Produk) ─────────────
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final int crossAxisCount = getCrossAxisCount(
                    constraints.maxWidth,
                  );

                  // Jika data belum ada
                  if (_products.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 100),
                      alignment: Alignment.center,
                      child: Text(
                        "Tidak ada produk yang tersedia saat ini.",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // GridView Produk
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.all(10),
                    childAspectRatio: 0.65,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        _products.map((product) {
                          final String imageUrl =
                              "http://192.168.18.38:8000/storage/product_image/${product.image}";

                          return GestureDetector(
                            onTap: () {
                              // **Navigator tanpa persistent bottom‑nav**
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          DetailProductPage(product: product),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ── Gambar ──
                                  Expanded(
                                    flex: 6,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        _,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (_, __, ___) => const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    ),
                                  ),
                                  // ── Nama & Harga ──
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (product.specification.isNotEmpty)
                                            Text(
                                              'Rp ${product.specification[0].price}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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
