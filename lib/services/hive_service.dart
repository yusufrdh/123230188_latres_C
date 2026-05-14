import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

class HiveService {
  static const String _boxName = 'cartBox';

  Future<Box<CartItem>> get _box async => await Hive.openBox<CartItem>(_boxName);

  Future<void> addToCart(CartItem newItem) async {
    final box = await _box;
    // Menggunakan composite key statis agar sinkron antar penambahan produk
    final compositeKey = '${newItem.username}_${newItem.productId}';

    if (box.containsKey(compositeKey)) {
      // Jika produk sudah ada, akumulasikan kuantitasnya agar harga tetap sinkron
      final existingItem = box.get(compositeKey)!;
      final updatedItem = CartItem(
        keyId: compositeKey,
        username: existingItem.username,
        productId: existingItem.productId,
        title: existingItem.title,
        price: existingItem.price,
        thumbnail: existingItem.thumbnail,
        quantity: existingItem.quantity + newItem.quantity,
      );
      await box.put(compositeKey, updatedItem);
    } else {
      await box.put(compositeKey, newItem);
    }
  }

  Future<List<CartItem>> getCartItems(String username) async {
    final box = await _box;
    return box.values.where((item) => item.username == username).toList();
  }

  Future<void> removeFromCart(String keyId) async {
    final box = await _box;
    await box.delete(keyId);
  }
}