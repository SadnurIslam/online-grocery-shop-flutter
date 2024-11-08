import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  user?.photoURL ?? 'https://via.placeholder.com/150'),
            ),
            SizedBox(height: 10),
            Text(user?.displayName ?? 'Guest',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user?.email ?? 'No email', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
