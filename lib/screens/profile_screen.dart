import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedGender = '';
  final List<String> genders = ['Male', 'Female', 'Other'];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _nameController.text = userDoc['name'] ?? user?.displayName ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
        _addressController.text = userDoc['address'] ?? '';
        _selectedGender = userDoc['gender'] ?? '';
      });
    }
  }

  Future<void> _updateUserProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'gender': _selectedGender,
    }, SetOptions(merge: true));

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://www.gravatar.com/avatar/placeholder?d=mp'), // Using Gravatar for placeholder
            ),
            SizedBox(height: 10),
            Text(user?.email ?? 'No email available',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 95, 90, 90))),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: isEditing,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              enabled: isEditing,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender'),
              value: _selectedGender.isNotEmpty ? _selectedGender : null,
              items: genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: isEditing
                  ? (value) {
                      setState(() {
                        _selectedGender = value ?? '';
                      });
                    }
                  : null,
              disabledHint: Text(_selectedGender.isNotEmpty
                  ? _selectedGender
                  : 'Select Gender'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              enabled: isEditing,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  _updateUserProfile();
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
              child: Text(isEditing ? 'Save' : 'Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
