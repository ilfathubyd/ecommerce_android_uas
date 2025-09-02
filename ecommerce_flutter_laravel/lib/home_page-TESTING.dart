// import 'package:ecommerce_flutter_laravel/API/ProductService.dart';
// import 'package:ecommerce_flutter_laravel/model/model.dart';
// import 'package:flutter/material.dart';
// import 'detail_product_page.dart';

// class HomePage extends StatelessWidget {
//   HomePage({super.key});

//   /// IP / domain back‑end Laravel Anda
//   final String baseUrl = 'http://192.168.18.38:8000';

//   /// Tentukan jumlah kolom grid sesuai lebar layar
//   int _crossAxisCount(double width) {
//     if (width < 600) return 2;        // smartphone
//     if (width < 900) return 4;        // tablet
//     return 5;                         // desktop
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Java's Store"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: FutureBuilder<List<Product>>(
//         future: Productservice().getProduct(),      // ⇦ ambil data ke API
//         builder: (context, snapshot) {
//           // ---------------- STATE: LOADING ----------------
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // ---------------- STATE: ERROR ------------------
//           if (snapshot.hasError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Text(
//                   'Gagal memuat produk:\n${snapshot.error}',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           }

//           // ---------------- STATE: DATA -------------------
//           final products = snapshot.data ?? [];

//           if (products.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Tidak ada produk tersedia.',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             );
//           }

//           return CustomScrollView(
//             slivers: [
//               // ---------- HERO SECTION ----------
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     const Text(
//                       'Welcome To Our Store',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     const SizedBox(height: 20),
//                     Image.asset(
//                       'assets/images/redmi-note-14-series.jpg',
//                       width: double.infinity,
//                       height: screenWidth * 0.5,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),

//               // ---------- GRID SECTION ----------
//               SliverPadding(
//                 padding: const EdgeInsets.all(10),
//                 sliver: SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: _crossAxisCount(screenWidth),
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     childAspectRatio: 0.65,
//                   ),
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       final product = products[index];
//                       final imageUrl =
//                           '$baseUrl/storage/product_image/${product.image}';

//                       return GestureDetector(
//                         onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => DetailProductPage(product: product),
//                           ),
//                         ),
//                         child: Card(
//                           clipBehavior: Clip.antiAlias,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // ---------- GAMBAR ----------
//                               Expanded(
//                                 flex: 6,
//                                 child: Image.network(
//                                   imageUrl,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, progress) =>
//                                       progress == null
//                                           ? child
//                                           : const Center(
//                                               child:
//                                                   CircularProgressIndicator()),
//                                   errorBuilder: (_, __, ___) => const Center(
//                                     child: Icon(Icons.broken_image,
//                                         size: 40, color: Colors.grey),
//                                   ),
//                                 ),
//                               ),
//                               // ---------- TEKS ----------
//                               Expanded(
//                                 flex: 4,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         product.name,
//                                         textAlign: TextAlign.center,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       if (product.specification.isNotEmpty)
//                                         Text(
//                                           'Rp ${product.specification.first.price}',
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.deepOrange,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: products.length,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
