import 'package:flutter/material.dart';
import 'package:newapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          user != null
              ? ListTile(
                  leading: user.photoURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                        )
                      : CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.displayName ?? "User"),
                  subtitle: Text(user.email ?? ""),
                )
              : SizedBox.shrink(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorites"),
            onTap: () {
              // Navigate to favorites screen
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Order History"),
            onTap: () {
              // Navigate to order history screen
            },
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text("Contact Support"),
            onTap: () {
              // Navigate to support screen
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
