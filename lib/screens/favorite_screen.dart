import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatelessWidget {
  final String userId;

  FavoritesPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var favorites = snapshot.data!.get('products') as List;

          if (favorites.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              var product = favorites[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('\$${product['price']}'),
                leading: Image.network(product['imageUrl']),
              );
            },
          );
        },
      ),
    );
  }
}
