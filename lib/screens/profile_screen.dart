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
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://www.gravatar.com/avatar/placeholder?d=mp'), // Using Gravatar for placeholder
              backgroundColor: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              user?.email ?? 'No email available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 30),
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_phoneController, 'Phone',
                keyboardType: TextInputType.phone),
            _buildGenderDropdown(),
            _buildTextField(_addressController, 'Address'),
            SizedBox(height: 30),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Edit Profile',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 241, 234, 234)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        keyboardType: keyboardType,
        enabled: isEditing,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
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
        disabledHint: Text(
            _selectedGender.isNotEmpty ? _selectedGender : 'Select Gender'),
      ),
    );
  }
}
