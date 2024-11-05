import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: 3, // Replace with actual cart item count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset('assets/images/sample.jpg', width: 50),
            title: Text('Sample Product'),
            subtitle: Text('৳100'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // Decrease quantity logic
                  },
                ),
                Text("1"), // Replace with actual quantity
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Increase quantity logic
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {
            // Proceed to checkout
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
