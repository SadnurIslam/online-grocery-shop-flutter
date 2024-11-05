import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final String imageUrl;

  const ProductCard(
      {super.key,
      required this.productName,
      required this.price,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imageUrl, fit: BoxFit.cover, height: 100),
          Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('৳$price', style: TextStyle(color: Colors.green)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // Handle favorite action
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Handle add to cart action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
