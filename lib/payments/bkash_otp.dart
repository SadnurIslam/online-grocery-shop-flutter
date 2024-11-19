import 'package:flutter/material.dart';
import 'package:newapp/payments/bkash_pin.dart';

class BkashOTPPage extends StatelessWidget {
  final double totalPrice;

  BkashOTPPage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    // Function to validate OTP input
    void validateAndProceed() {
      String otp = otpController.text.trim();

      if (otp.length != 4 || int.tryParse(otp) == null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid 4-digit OTP.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Navigate to PIN Page if OTP is valid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BkashPinPage(totalPrice: totalPrice),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('bKash Payment'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // bKash Logo from online
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

            // Enter OTP Prompt
            Text(
              'Enter the verification code sent to your bKash number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // OTP Input Field
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 4, // Restrict to 4 digits
              decoration: InputDecoration(
                hintText: 'Enter 4-digit OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.pink),
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
