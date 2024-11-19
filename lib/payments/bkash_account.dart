import 'package:flutter/material.dart';
import 'package:newapp/payments/bkash_otp.dart';

class BkashAccountPage extends StatelessWidget {
  final double totalPrice;

  BkashAccountPage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final TextEditingController accountController = TextEditingController();

    // Function to validate phone number
    void validateAndProceed() {
      String phoneNumber = accountController.text.trim();

      if (phoneNumber.length != 11 || !phoneNumber.startsWith('01')) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid 11-digit bKash number starting with "01".',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Navigate to OTP Page if valid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BkashOTPPage(totalPrice: totalPrice),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('bKash Payment'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // bKash Logo
            Image.network(
              'https://ahkhan.com/wp-content/uploads/2018/07/Bkash-Customer-Care1.png',
              height: 80,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 16),

            // Shop Name
            Text(
              'FreshMart',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),

            // Total Price Display
            Text(
              'Total: ৳${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 32),

            // Enter bKash Account Number
            Text(
              'Enter your bKash Account Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // Input Field
            TextField(
              controller: accountController,
              keyboardType: TextInputType.phone,
              maxLength: 11, // Restrict to 11 digits
              decoration: InputDecoration(
                hintText: 'e.g. 01XXXXXXXXX',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.phone, color: Colors.pink),
              ),
            ),
            SizedBox(height: 24),

            // Confirm Button
            ElevatedButton(
              onPressed: validateAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Button color
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'CONFIRM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
