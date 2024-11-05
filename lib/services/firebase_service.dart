import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/models/product.dart';
import 'package:newapp/models/category.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Category>> fetchCategories() async {
    final snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }
}
