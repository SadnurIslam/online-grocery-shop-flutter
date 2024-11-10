import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double totalPrice = 0.0;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      double tempTotalPrice = 0.0;
      List<Map<String, dynamic>> tempCartItems = [];

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        double price = data['discountPrice'] ?? data['price'];
        int quantity = data['quantity'] ?? 1;

        tempTotalPrice += price * quantity;
        tempCartItems.add({
          'name': data['name'],
          'price': price,
          'quantity': quantity,
          'imageUrl': data['imageUrl'],
        });
      }

      setState(() {
        totalPrice = tempTotalPrice;
        cartItems = tempCartItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item['imageUrl'], width: 50),
                  title: Text(item['name']),
                  subtitle: Text('৳${item['price']} x ${item['quantity']}'),
                  trailing: Text('৳${item['price'] * item['quantity']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: ৳$totalPrice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add order confirmation or payment logic here
                  },
                  child: Text('Confirm Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
