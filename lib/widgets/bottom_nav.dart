import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomNav extends StatelessWidget {
  final Function onCartTap;

  const BottomNav({super.key, required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == 0) {
          // Navigate to Home
          Navigator.pushNamed(context, '/home');
        } else if (index == 1) {
          // Check if the user is logged in before navigating to Cart
          if (user == null) {
            // Show login prompt if not logged in
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please log in to view your cart.')),
            );
            Navigator.pushNamed(context, '/login');
          } else {
            Navigator.pushNamed(context, '/cart');
          }
        } else if (index == 2) {
          // Check if the user is logged in before navigating to Profile
          if (user == null) {
            // Show login prompt if not logged in
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please log in to view your profile.')),
            );
            Navigator.pushNamed(context, '/login');
          } else {
            Navigator.pushNamed(context, '/profile');
          }
        }
      },
    );
  }
}
