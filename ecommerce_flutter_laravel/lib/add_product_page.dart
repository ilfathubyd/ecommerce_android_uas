
  import 'package:ecommerce_flutter_laravel/navigation_bar.dart';
  import 'package:ecommerce_flutter_laravel/services/product_services.dart';
  import 'package:ecommerce_flutter_laravel/widget/CustomTextField.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'dart:typed_data';




  class AddProductPage extends StatefulWidget {
    const AddProductPage({super.key});

    @override
    State<AddProductPage> createState() => _AddProductPageState();
  }

  class _AddProductPageState extends State<AddProductPage> {
    final _formKey = GlobalKey<FormState>();

    // controller input
    final _nameCtrl    = TextEditingController();
    final _storageCtrl = TextEditingController();
    final _priceCtrl   = TextEditingController();

    // image picker
    final _picker = ImagePicker();
    Uint8List? _imageBytes;         // gambar sebagai bytes
    bool _isLoading = false;

    @override
    void dispose() {
      _nameCtrl.dispose();
      _storageCtrl.dispose();
      _priceCtrl.dispose();
      super.dispose();
    }

    // ── pilih gambar dari galeri ────────────────────────────────────────────────
    Future<void> _pickImage() async {
      try {
        final picked = await _picker.pickImage(source: ImageSource.gallery);
        if (picked == null) return;

        final bytes = await picked.readAsBytes();
        setState(() => _imageBytes = bytes);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
      }
    }

    // ── submit form ─────────────────────────────────────────────────────────────
    Future<void> _submit() async {
      if (!_formKey.currentState!.validate() || _imageBytes == null) {
        if (_imageBytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan pilih gambar terlebih dahulu.')),
          );
        }
        return;
      }

      setState(() => _isLoading = true);

      try {
        await ProductService().addProduct(
          name: _nameCtrl.text,
          storage: _storageCtrl.text,
          price: _priceCtrl.text,
          imageBytes: _imageBytes!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan!')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ButtomNavigationBar()),
            (_) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Gagal: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    // ── UI ──────────────────────────────────────────────────────────────────────
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text('Tambah Produk Baru',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // preview gambar
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageBytes == null
                        ? const Center(child: Text('Belum ada gambar dipilih'))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih dari Galeri'),
                  ),
                  const SizedBox(height: 20),

                  // input field
                  textFieldCustom('Masukkan Nama Produk', _nameCtrl),
                  textFieldCustom('Masukkan Storage', _storageCtrl),
                  textFieldCustom('Masukkan Harga', _priceCtrl, isPrice: true),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Tambahkan Produk'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
