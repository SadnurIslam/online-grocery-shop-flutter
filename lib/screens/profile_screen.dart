import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  NetworkImage(user.photoURL ?? 'default_image_url'),
            ),
            SizedBox(height: 10),
            Text(user.displayName ?? 'Guest',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user.email ?? '', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
