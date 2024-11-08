import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCard extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final double discountPrice;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .doc(widget.productId)
          .get();
      setState(() {
        isFavorite = doc.exists;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (user != null) {
      final favRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .doc(widget.productId);

      if (isFavorite) {
        await favRef.delete();
      } else {
        await favRef.set({
          'name': widget.productName,
          'price': widget.price,
          'discountPrice': widget.discountPrice,
          'imageUrl': widget.imageUrl,
        });
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      Navigator.of(context).pushNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Product Details
        Navigator.of(context)
            .pushNamed('/productDetails', arguments: widget.productId);
      },
      child: Card(
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(widget.imageUrl,
                  height: 120, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (widget.discountPrice < widget.price)
                        Text(
                          '৳${widget.price}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      SizedBox(width: 6),
                      Text(
                        '৳${widget.discountPrice}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          if (user != null) {
                            _addToCart(user!.uid);
                          } else {
                            Navigator.of(context).pushNamed('/login');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(String userId) async {
    // Add product to user's cart collection in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(widget.productId)
        .set({
      'name': widget.productName,
      'price': widget.price,
      'discountPrice': widget.discountPrice,
      'imageUrl': widget.imageUrl,
      'quantity': 1, // Starting with quantity 1
    });
  }
}
