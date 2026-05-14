import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/hive_service.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final String username;

  const DetailPage({super.key, required this.product, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final HiveService _hiveService = HiveService();
  int _quantity = 1;

  void _incrementQty() {
    if (_quantity < widget.product.stock) {
      setState(() => _quantity++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok maksimum untuk produk ini adalah ${widget.product.stock}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _decrementQty() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() async {
    final compositeKey = '${widget.username}_${widget.product.id}';
    final cartItem = CartItem(
      keyId: compositeKey,
      username: widget.username,
      productId: widget.product.id,
      title: widget.product.title,
      price: widget.product.price,
      thumbnail: widget.product.thumbnail,
      quantity: _quantity,
    );

    await _hiveService.addToCart(cartItem);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item berhasil ditambahkan ke keranjang'),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color(0xFF0F172A);
    const Color bgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryDark, size: 20),
        title: const Text('Detail Produk', style: TextStyle(color: primaryDark, fontSize: 15, fontWeight: FontWeight.w700)),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.black.withOpacity(0.04), height: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container penampung gambar eksklusif
            Container(
              color: bgColor,
              width: double.infinity,
              height: 280,
              padding: const EdgeInsets.all(16),
              child: Image.network(widget.product.thumbnail, fit: BoxFit.contain),
            ),
            
            // Rincian Informasi
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                        child: Text('STOK: ${widget.product.stock}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black54)),
                      ),
                      Text('\$${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primaryDark, height: 1.25)),
                  const SizedBox(height: 24),
                  const Text('Rincian Produk', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: primaryDark)),
                  const SizedBox(height: 8),
                  Text(widget.product.description, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.65)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -2))]),
        child: SafeArea(
          child: Row(
            children: [
              // Pemilih kuantitas minimalis
              Container(
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove, size: 16, color: primaryDark), onPressed: _decrementQty),
                    SizedBox(width: 24, child: Text('$_quantity', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: primaryDark))),
                    IconButton(icon: const Icon(Icons.add, size: 16, color: primaryDark), onPressed: _incrementQty),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.product.stock > 0 ? _addToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('TAMBAH KE KERANJANG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}