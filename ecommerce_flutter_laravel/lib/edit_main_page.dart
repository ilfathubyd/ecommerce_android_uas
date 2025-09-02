import 'package:ecommerce_flutter_laravel/API/ProductService.dart';
import 'package:ecommerce_flutter_laravel/list_product_type.dart';
import 'package:ecommerce_flutter_laravel/model/modelBACKUP.dart';
import 'package:flutter/material.dart';
class EditMainPage extends StatefulWidget {
  const EditMainPage({super.key});

  @override
  State<EditMainPage> createState() => _EditMainPageState();
}

class _EditMainPageState extends State<EditMainPage> {

  int getCrossAxisCount(double width) {
    if (width < 600) {
      return 2; // smartphone
    } else if (width < 900) {
      return 4; // tablet kecil
    } else {
      return 5; // tablet besar / desktop
    }
  }

  late Future data;

  List<Product> data2 = [];

  late Future<List<Product>> _productsData;
  final Productservice apiService = Productservice();

  @override
  void initState() {
    data = Productservice().getProduct();
    data.then((value){
      setState(() {
        data2 = value;
      });
    });
    super.initState();
    _getData();
  }

  void _getData() {
    setState(() {
      _productsData = apiService.getProduct();
    });
  }

  Future<void> _deleteProduct(Product product) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus produk "${product.name}" beserta semua variannya?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await apiService.deleteProduct(productId: product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${product.name}" berhasil dihapus.')),
          );
        }
        _getData(); // Refresh daftar produk
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: ${e.toString()} "${product.name}" "${product.id}"')),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    // double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Controller Product", style: TextStyle(color: Colors.white)),
        ),
        body: FutureBuilder<List<Product>>(
          future: _productsData,
          builder: (context, snapshot) {
            // Kondisi saat data masih loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Kondisi jika terjadi error
            if (snapshot.hasError) {
              return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
            }

            // Kondisi jika data kosong
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada produk."));
            }

            // Jika data berhasil didapat, 'snapshot.data' akan berisi List<Product>
            final products = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = getCrossAxisCount(constraints.maxWidth); // Asumsi fungsi ini ada

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  childAspectRatio: 0.65,
                  
                  children: products.map((product) {
                    final imageUrl = "http://192.168.18.38:8000/storage/product_image/${product.image}";
                    
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.error, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          SizedBox(height: 12),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    iconColor: Colors.white
                                  ),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListProductType(product: product),
                                      ),
                                    );
                                  }, 
                                  child: Icon(Icons.edit)
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    iconColor: Colors.white
                                  ),
                                  onPressed: () async {
                                    await _deleteProduct(product);
                                  }, 
                                  child: Icon(Icons.delete)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


