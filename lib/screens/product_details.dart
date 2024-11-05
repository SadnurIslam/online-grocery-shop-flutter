import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final double price;
  final double discountPrice;
  final String description;

  const ProductDetails({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.discountPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imageUrl,
                width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    '৳$discountPrice',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '৳$price',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(description),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Buy now action
                },
                child: Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
