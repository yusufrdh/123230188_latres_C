import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final HiveService _hiveService = HiveService();
  final AuthService _authService = AuthService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    final username = await _authService.getLoggedInUser() ?? '';
    final items = await _hiveService.getCartItems(username);
    
    double total = 0.0;
    for (var item in items) {
      total += (item.price * item.quantity);
    }

    setState(() {
      _cartItems = items;
      _totalPrice = total;
      _isLoading = false;
    });
  }

  void _removeItem(String keyId) async {
    await _hiveService.removeFromCart(keyId);
    _loadCart();
  }

  void _processCheckout() async {
    final paidTotal = _totalPrice; 
    
    for (var item in _cartItems) {
      await _hiveService.removeFromCart(item.keyId);
    }
    
    if (mounted) {
      const Color primaryDark = Color(0xFF0F172A);
      
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_outline_rounded, size: 48, color: primaryDark),
                ),
                const SizedBox(height: 16),
                const Text('Pembayaran Berhasil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: primaryDark)),
                const SizedBox(height: 6),
                Text('Total transaksi senilai \$${paidTotal.toStringAsFixed(2)} telah diproses.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryDark, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('KEMBALI KE BERANDA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      _loadCart(); 
    }
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
        iconTheme: const IconThemeData(color: primaryDark, size: 20),
        title: const Text('Keranjang', style: TextStyle(color: primaryDark, fontSize: 15, fontWeight: FontWeight.w700)),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.black.withOpacity(0.04), height: 1)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryDark, strokeWidth: 2.5))
          : _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 56, color: Colors.black.withOpacity(0.15)),
                      const SizedBox(height: 16),
                      const Text('Keranjang Kosong', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: primaryDark)),
                      const SizedBox(height: 4),
                      const Text('Belum ada pesanan yang ditambahkan.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(item.thumbnail, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 64, height: 64, color: bgColor, child: const Icon(Icons.image_not_supported_outlined, size: 16, color: Colors.black26))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: primaryDark)),
                                const SizedBox(height: 6),
                                Text('\$${item.price.toStringAsFixed(2)}  x  ${item.quantity}', style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primaryDark)),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.black38, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                            onPressed: () => _removeItem(item.keyId),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: _cartItems.isEmpty ? null : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -2))]),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL PEMBAYARAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: primaryDark)),
                ],
              ),
              ElevatedButton(
                onPressed: _processCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('CHECKOUT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}