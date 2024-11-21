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

  // Check if the product is in the cart
  Future<bool> isInCart(String productId) async {
    final cartDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .doc(productId);

    final snapshot = await cartDoc.get();
    return snapshot.exists;
  }

  // Method to toggle product in the cart
  Future<void> toggleCart(
      Map<String, dynamic> product, String productId) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart');

    final cartDoc =
        cartRef.doc(productId); // Reference to the product in the cart

    final cartSnapshot = await cartDoc.get();

    if (cartSnapshot.exists) {
      // If the product is already in the cart, remove it
      await cartDoc.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from cart!')),
      );
    } else {
      // Add the product to the cart
      await cartDoc.set({
        'name': product['name'],
        'price': product['price'],
        'discountPrice': product['discountPrice'],
        'imageUrl': product['imageUrl'],
        'quantity': 1, // Set a default quantity for new cart items
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: favoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Add your favorite products here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.65,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favoriteItem = favorites[index];
              final productId = favoriteItem.id;
              final data = favoriteItem.data();
              final price = data['price'];
              final discountPrice = data['discountPrice'];
              final isDiscounted =
                  discountPrice != null && discountPrice < price;

              return FutureBuilder<bool>(
                future: isInCart(productId),
                builder: (context, snapshot) {
                  final isInCart = snapshot.data ?? false;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              data['imageUrl'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 50),
                            ),
                          ),
                        ),

                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Product Price
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  if (isDiscounted)
                                    Text(
                                      '৳$discountPrice',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  if (isDiscounted) SizedBox(width: 8),
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
                            ],
                          ),
                        ),

                        // Icons (Cart and Remove)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Cart Icon
                              IconButton(
                                onPressed: () => toggleCart(data, productId),
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: isInCart ? Colors.green : Colors.grey,
                                ),
                                tooltip: isInCart
                                    ? 'Remove from Cart'
                                    : 'Add to Cart',
                              ),

                              // Remove Icon
                              IconButton(
                                onPressed: () => removeFavorite(productId),
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Remove from Favorites',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
