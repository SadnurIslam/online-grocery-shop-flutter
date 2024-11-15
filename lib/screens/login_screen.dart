import 'package:flutter/material.dart';
import 'package:newapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    'https://img.freepik.com/premium-photo/supermarket-trolley-cart-with-fresh-products-red-handle-3d-realistic-grocery-cart-shopping-cart-full-food-grocery-food-store-concept-generative-ai_528152-716.jpg?w=740',
                    height: 200,
                    width: 200,
                    fit: BoxFit
                        .cover, // Ensures the image fits within the circular frame
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Welcome to Grocery Shop",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authService.signInWithGoogle();
                    if (authService.isSignedIn) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 71, 71),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  icon: FaIcon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                        color: Color.fromARGB(255, 233, 222, 222),
                        fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authService.signInWithGoogle();
                    if (authService.isSignedIn) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: FaIcon(
                    Icons.facebook,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Sign in with Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
