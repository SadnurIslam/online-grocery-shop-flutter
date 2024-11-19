import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newapp/payments/order_confirmation_page.dart';

class BkashPinPage extends StatelessWidget {
  final double totalPrice;
  final TextEditingController pinController = TextEditingController();

  BkashPinPage({Key? key, required this.totalPrice}) : super(key: key);

  /// Retrieve the current user ID
  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  /// Confirm the order and save it to Firestore
  Future<void> _confirmOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to place an order.')),
      );
      return;
    }

    final String userId = user.uid;

    try {
      // Fetch items from the cart
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      List<Map<String, dynamic>> products = [];
      double totalOrderPrice = 0.0;

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        products.add({
          'name': data['name'],
          'price': data['price'],
          'discountPrice': data['discountPrice'],
          'quantity': data['quantity'],
          'imageUrl': data['imageUrl'],
        });
        totalOrderPrice +=
            (data['discountPrice'] ?? data['price']) * data['quantity'];
      }

      if (products.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Your cart is empty. Add items to the cart first.')),
        );
        return;
      }

      // Save the order in the 'orders' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .add({
        'products': products,
        'totalPrice': totalOrderPrice,
        'paymentMethod': 'Bkash',
        'status': 'Confirmed',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the cart after the order is placed
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      // Navigate to the Order Confirmation Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place the order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bKash Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter your bKash PIN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter 5-digit PIN',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (pinController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your bKash PIN.')),
                  );
                  return;
                }

                // Validate PIN length (optional, you can customize this)
                if (pinController.text.length != 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN must be 5 digits.')),
                  );
                  return;
                }

                // Call the confirm order function
                await _confirmOrder(context);
              },
              child: Text('CONFIRM'),
            ),
          ],
        ),
      ),
    );
  }
}
