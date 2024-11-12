import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newapp/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Method to update the quantity of a product
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity > 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(productId)
          .update({'quantity': newQuantity});
    } else {
      // Remove product from cart if quantity is 0
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(productId)
          .delete();
    }
  }

  // Stream to listen for changes in cart items
  Stream<QuerySnapshot<Map<String, dynamic>>> cartItemsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cartItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              final productId = cartItem.id;
              final data = cartItem.data();
              final price = data['price'];
              final discountPrice = data['discountPrice'];
              final quantity = data['quantity'] ?? 1;
              final isDiscounted =
                  discountPrice != null && discountPrice < price;

              return ListTile(
                leading: Image.network(
                  data['imageUrl'],
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 50),
                ),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        updateQuantity(productId, quantity - 1);
                      },
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        updateQuantity(productId, quantity + 1);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CheckoutScreen()),
            );
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
