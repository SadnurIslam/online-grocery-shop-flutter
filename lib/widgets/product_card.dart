import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCard extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final String weight;
  const ProductCard(
      {Key? key,
      required this.productId,
      required this.productName,
      required this.price,
      required this.discountPrice,
      required this.imageUrl,
      required this.weight})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isInCart = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _checkCartStatus();
  }

  Future<void> _checkFavoriteStatus() async {
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

  Future<void> _checkCartStatus() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(widget.productId)
          .get();
      setState(() {
        isInCart = doc.exists;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (user == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.productId);

    if (isFavorite) {
      await favoriteRef.delete();
    } else {
      await favoriteRef.set({
        'name': widget.productName,
        'price': widget.price,
        'discountPrice': widget.discountPrice,
        'imageUrl': widget.imageUrl,
        'weight': widget.weight,
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _toggleCart() async {
    if (user == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .doc(widget.productId);

    if (isInCart) {
      await cartRef.delete();
    } else {
      await cartRef.set({
        'name': widget.productName,
        'price': widget.price,
        'discountPrice': widget.discountPrice,
        'imageUrl': widget.imageUrl,
        'quantity': 1,
      });
    }

    setState(() {
      isInCart = !isInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the discount percentage
    double discountPercentage =
        ((widget.price - widget.discountPrice) / widget.price) * 100;

    return GestureDetector(
      onTap: () {
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    widget.imageUrl,
                    height: 133,
                    width: double
                        .infinity, // Ensures the image fills the width of the card
                    fit: BoxFit.fill,
                  ),
                ),
                if (widget.discountPrice < widget.price)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${discountPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.productName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Weight
                  Text(
                    widget.weight, // Display the weight field here
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  // Price Section
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

                  // Favorite and Cart Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      IconButton(
                        icon: Icon(
                          isInCart
                              ? Icons.shopping_cart
                              : Icons.add_shopping_cart,
                          color: isInCart ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _toggleCart,
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
}
