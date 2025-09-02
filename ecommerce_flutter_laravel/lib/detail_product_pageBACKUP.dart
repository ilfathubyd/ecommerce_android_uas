// lib/detail_product_pageBACKUP.dart
import 'package:ecommerce_flutter_laravel/CheckoutScreen.dart';
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailProductPage extends StatefulWidget {
  final Product product;
  const DetailProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
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
    selectedSpecification =
        widget.product.specification.isNotEmpty
            ? widget.product.specification.first
            : Specification(
              id: -1,
              storage: '-',
              price: '0',
              productId: 0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "http://192.168.18.38:8000/storage/product_image/${widget.product.image}";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      /***  BOTTOM BAR ***/
      bottomNavigationBar: _BottomActionBar(
        onBuy: _handleBuyNow,
        onAddCart: () {}, // TODO
        onChat: () {}, // TODO
      ),

      /***  BODY (as is) ***/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            expandedHeight: 280,
            pinned: true,
            leading: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Colors.black26),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Text(
                widget.product.name,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 120,
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
            ),
          ),
          // ───── Harga — Nama — Penjualan ─────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(
                          int.tryParse(
                                selectedSpecification.price.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                ),
                              ) ??
                              0,
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Terjual 999+",
                          style: GoogleFonts.montserrat(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (i) =>
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 10)),

          // ───── Variasi Produk ─────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Varian",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.specification.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, idx) {
                        final spec = widget.product.specification[idx];
                        final isSelected = selectedSpecification.id == spec.id;
                        return ChoiceChip(
                          label: Text(
                            spec.storage,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.deepOrange,
                          backgroundColor: Colors.grey[100],
                          onSelected:
                              (_) =>
                                  setState(() => selectedSpecification = spec),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Spacer supaya konten tidak tertutup bottom bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  /* ===== BUY NOW ACTION ===== */
  void _handleBuyNow() {
    final item = CheckoutItem(
      product: widget.product,
      spec: selectedSpecification,
      qty: 1,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Checkout(item: item)),
    );
  }
}

/* ===== WIDGET BOTTOM ACTION BAR (unchanged selain onBuy) ===== */
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onChat, onAddCart, onBuy;
  const _BottomActionBar({
    required this.onChat,
    required this.onAddCart,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        children: [
          _MiniButton(icon: Icons.chat_outlined, label: "Chat", onTap: onChat),
          _Separator(),
          _MiniButton(
            icon: Icons.shopping_basket_outlined,
            label: "Keranjang",
            onTap: onAddCart,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onBuy,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                ),
                child: Text(
                  "Beli Sekarang",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.deepOrange, size: 20),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    height: 20,
    width: 1,
    color: Colors.grey[300],
  );
}
