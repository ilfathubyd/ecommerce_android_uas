import 'dart:io';
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:ecommerce_flutter_laravel/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'API/ProductService.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  final Specification variant; 
  const EditProductPage({
    super.key, 
    required this.product, 
    required this.variant
  });
  
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final storageController = TextEditingController(); // Ini untuk varian/spesifikasi
  final priceController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // DIUBAH: initState untuk mengisi data awal
  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data dari produk yang dilewatkan
    nameController.text = widget.product.name;

    // Asumsi kita mengedit spesifikasi/varian pertama dari produk
    storageController.text = widget.variant.storage; 
    priceController.text = widget.variant.price;
  }

  @override
  void dispose() {
    nameController.dispose();
    storageController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memilih gambar: $e")),
      );
    }
  }

  // DIUBAH: Fungsi untuk UPDATE form
  Future<void> _updateForm() async {
    if (formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      try {
        await Productservice().updateProduct(
          productId: widget.product.id, // Kirim ID produk
          variantId: widget.variant.id,
          name: nameController.text,
          storage: storageController.text,
          price: priceController.text,
          imagePath: _imageFile?.path, // Kirim path gambar baru jika ada
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil diperbarui!")),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // URL dasar gambar, sesuaikan jika perlu
    final String imageUrl = "http://19.45.13.36:8000/storage/product_image/${widget.product.image}";

    return Scaffold(

      appBar: AppBar(
        title: Text("Edit Produk ${widget.product.name} id ${widget.product.id} varian ${widget.variant.id}"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // DIUBAH: UI untuk preview gambar
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: _imageFile == null
                        // Jika tidak ada gambar baru, tampilkan gambar lama dari network
                        ? Image.network(
                            imageUrl, 
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Center(child: Text("Gagal memuat gambar")),
                            loadingBuilder: (c, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          )
                        // Jika ada gambar baru, tampilkan
                        : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Ubah Gambar"),
                ),
                const SizedBox(height: 20),

                textFieldCustom("Nama Produk", nameController),
                textFieldCustom("Varian (Contoh: 8/256)", storageController),
                textFieldCustom("Harga", priceController),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    // DIUBAH: Panggil _updateForm
                    onPressed: _isLoading ? null : _updateForm,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        // DIUBAH: Teks tombol
                        : const Text("Simpan Perubahan"),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}