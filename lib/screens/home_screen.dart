import 'package:flutter/material.dart';
import 'package:newapp/widgets/product_card.dart';
import 'package:newapp/widgets/category_chip.dart';
import 'package:newapp/widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryChip(
                  categoryName: 'Popular',
                  isSelected: true,
                  onSelected: () {
                    // Handle category selection
                  },
                ),
                CategoryChip(
                  categoryName: 'Food',
                  onSelected: () {
                    // Handle category selection
                  },
                ),
                CategoryChip(
                  categoryName: 'Cleaning Supplies',
                  onSelected: () {
                    // Handle category selection
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  productName: 'Sample Product',
                  price: 100,
                  imageUrl: 'assets/images/sample.jpg',
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
