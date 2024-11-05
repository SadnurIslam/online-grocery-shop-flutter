import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      discountPrice: data['discountPrice'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
