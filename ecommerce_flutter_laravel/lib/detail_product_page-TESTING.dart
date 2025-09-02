
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailProductPage extends StatefulWidget {
  final Product product;

  const DetailProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late Specification selectedSpecification;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.product.specification.isNotEmpty) {
      selectedSpecification = widget.product.specification.first;
    } else {
      // selectedSpecification = Specification(price: '0', storage: '128/2', id: 123, productId: 123, createdAt: null, updatedAt: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.product.image.contains('.jpg') || widget.product.image.contains('.png')
        ? 'assets/images/${widget.product.image}'
        : "http://192.168.18.38:8000/storage/product_image/${widget.product.image}";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(widget.product.name, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: widget.product.image.contains('http')
                        ? Image.network(imageUrl, height: 250, fit: BoxFit.contain)
                        : Image.asset(imageUrl, height: 250, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatter.format(
                          int.tryParse(selectedSpecification.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Terjual 999+", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.product.specification.isNotEmpty)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pilih Varian", style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.specification.length,
                            itemBuilder: (context, index) {
                              final spec = widget.product.specification[index];
                              final isSelected = selectedSpecification.id == spec.id;
                              return GestureDetector(
                                onTap: () => setState(() => selectedSpecification = spec),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.deepOrange.withOpacity(0.1) : Colors.white,
                                    border: Border.all(
                                      color: isSelected ? Colors.deepOrange : Colors.grey,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      spec.storage,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? Colors.deepOrange : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -1),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_outlined, size: 18, color: Colors.deepOrange),
                        Text("Chat", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_basket_outlined, size: 18, color: Colors.deepOrange),
                        Text("Keranjang", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Beli Sekarang", style: GoogleFonts.montserrat(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
