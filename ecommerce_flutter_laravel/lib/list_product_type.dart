import 'package:ecommerce_flutter_laravel/edit_product_page.dart';
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- Jangan lupa import ini

class ListProductType extends StatelessWidget {
  final Product product;
  const ListProductType({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final baseUrl = 'http://192.168.18.38:8000/storage/product_image/';

    return Scaffold(
      appBar: AppBar(
        title: Text("Varian untuk ${product.name} id ${product.id}"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: product.specification.isEmpty
          ? const Center(
              child: Text("Produk ini tidak memiliki varian."),
            )
          : ListView.builder(
              itemCount: product.specification.length,
              itemBuilder: (context, index) {
                final variant = product.specification[index];
                final imageUrl = '$baseUrl${product.image}';

                // 1. Buat formatter untuk format angka Indonesia
                final formatter = NumberFormat('#,###', 'id_ID');
                
                // 2. Parse harga dari String ke int
                final int priceAsInt = int.tryParse(variant.price) ?? 0;
                
                // 3. Format harga menjadi String dengan titik ribuan
                final String formattedPrice = formatter.format(priceAsInt);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                    title: Text(variant.storage, style: TextStyle(fontWeight: FontWeight.bold)),
                    
                    // 4. Tampilkan harga yang sudah rapi
                    subtitle: Text("Harga: Rp $formattedPrice"), 

                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProductPage(
                            product: product, 
                            variant: variant,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}