import 'package:hive/hive.dart';

class CartItem {
  final String keyId;
  final String username;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;

  CartItem({
    required this.keyId,
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
  });
}

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 0;

  @override
  CartItem read(BinaryReader reader) {
    return CartItem(
      keyId: reader.readString(),
      username: reader.readString(),
      productId: reader.readInt(),
      title: reader.readString(),
      price: reader.readDouble(),
      thumbnail: reader.readString(),
      quantity: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer.writeString(obj.keyId);
    writer.writeString(obj.username);
    writer.writeInt(obj.productId);
    writer.writeString(obj.title);
    writer.writeDouble(obj.price);
    writer.writeString(obj.thumbnail);
    writer.writeInt(obj.quantity);
  }
}