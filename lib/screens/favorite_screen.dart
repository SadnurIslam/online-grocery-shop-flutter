import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Stream to listen for changes in the user's favorites
  Stream<QuerySnapshot<Map<String, dynamic>>> favoritesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .snapshots();
  }

  // Method to remove a product from favorites
  Future<void> removeFavorite(String productId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: favoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favoriteItem = favorites[index];
              final productId = favoriteItem.id;
              final data = favoriteItem.data();
              final price = data['price'];
              final discountPrice = data['discountPrice'];
              final isDiscounted =
                  discountPrice != null && discountPrice < price;

              return ListTile(
                title: Text(data['name']),
                subtitle: Row(
                  children: [
                    if (isDiscounted)
                      Text(
                        '৳$discountPrice ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    if (isDiscounted)
                      Text(
                        '৳$price',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (!isDiscounted)
                      Text(
                        '৳$price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
                leading: Image.network(
                  data['imageUrl'],
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 50),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeFavorite(productId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
