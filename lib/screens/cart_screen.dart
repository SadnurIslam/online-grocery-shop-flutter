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
        title: Text(
          "My Cart",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: cartItemsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            final cartItems = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
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

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  if (isDiscounted)
                                    Text(
                                      '৳$discountPrice ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  if (isDiscounted)
                                    Text(
                                      '৳$price',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  if (!isDiscounted)
                                    Text(
                                      '৳$price',
                                      style: const TextStyle(
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
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                updateQuantity(productId, quantity - 1);
                              },
                              color: Colors.red,
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                updateQuantity(productId, quantity + 1);
                              },
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: cartItemsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                      'Total: ৳0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  double total = snapshot.data!.docs.fold(
                    0.0,
                    (sum, doc) {
                      final price =
                          doc.data()['discountPrice'] ?? doc.data()['price'];
                      final quantity = doc.data()['quantity'] ?? 1;
                      return sum + (price * quantity);
                    },
                  );

                  return Text(
                    'Total: ৳${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              },
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
