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
      appBar: AppBar(
        title: Text('bKash Payment'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo and Heading
            Column(
              children: [
                Image.network(
                  'https://ahkhan.com/wp-content/uploads/2018/07/Bkash-Customer-Care1.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  'Enter your bKash PIN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 30),

            // PIN Input Field
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                hintText: 'Enter 5-digit PIN',
                counterText: '', // Hide the counter below the TextField
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 30),

            // Confirm Button
            ElevatedButton(
              onPressed: () async {
                // Validate PIN input
                if (pinController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your bKash PIN.')),
                  );
                  return;
                }

                if (pinController.text.length != 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN must be exactly 5 digits.')),
                  );
                  return;
                }

                // Confirm order if validation passes
                await _confirmOrder(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'CONFIRM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
