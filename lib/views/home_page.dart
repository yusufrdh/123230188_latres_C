import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'cart_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  String _username = '';
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchData();
  }

  void _loadUser() async {
    final user = await _authService.getLoggedInUser();
    setState(() {
      _username = user ?? 'Pengguna';
    });
  }

  void _fetchData() {
    setState(() {
      _productsFuture = _apiService.fetchProducts();
    });
  }

  Future<void> _handleRefresh() async {
    _fetchData();
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color(0xFF0F172A);
    const Color bgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Hi, $_username', style: const TextStyle(color: primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: primaryDark, size: 20),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
            ),
          ),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.black.withOpacity(0.04), height: 1)),
      ),
      body: RefreshIndicator(
        color: primaryDark,
        backgroundColor: Colors.white,
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primaryDark, strokeWidth: 2.5));
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text('Gagal memuat katalog: ${snapshot.error}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchData,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryDark, foregroundColor: Colors.white, elevation: 0),
                      child: const Text('Coba Lagi', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Katalog produk kosong.', style: TextStyle(color: Colors.black54)));
            }

            final products = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(product: product, username: _username)));
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Gambar dengan fallback & skeleton loading bernuansa mahal
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.thumbnail,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                width: 72,
                                height: 72,
                                color: bgColor,
                                child: const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black26))),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: bgColor, child: const Icon(Icons.image_not_supported_outlined, size: 20, color: Colors.black26)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: primaryDark)),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: primaryDark)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                                    child: Text('Stok: ${product.stock}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}