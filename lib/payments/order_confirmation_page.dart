import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        backgroundColor: Colors.green, // Consistent FreshMart green
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/190/190411.png',
              height: 100,
            ),
            SizedBox(height: 20),

            // Confirmation Message
            Text(
              'Thank You for Your Order!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark text for contrast
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your order has been successfully placed.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700], // Subtle grey text
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Store Branding
            Text(
              'FreshMart Grocery Store',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800], // Accent green for branding
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'We deliver freshness to your door!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600], // Subtle grey for description
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Go to Homepage Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.home, color: Colors.white),
              label: Text(
                'Go to Homepage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green background for button
                // onPrimary: Colors.white, // White text/icon for contrast
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
