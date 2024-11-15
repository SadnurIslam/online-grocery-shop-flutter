import 'package:flutter/material.dart';
import 'package:newapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                'https://codeforces.com/userpic.codeforces.org/2378836/title/5c17df02f66ff8ba.jpg',
                height: 200,
                width: 200,
                fit: BoxFit
                    .cover, // Ensures the image fits within the circular frame
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Grocery Shop",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithGoogle();
                if (authService.isSignedIn) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text("Sign in with Google"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithGoogle();
                if (authService.isSignedIn) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text("Sign in with Facebook"),
            ),
          ],
        ),
      ),
    );
  }
}
