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
    if (user == null) return;

    final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('profiles')
        .doc('profile') // Assuming a single profile document
        .get();

    if (profileDoc.exists) {
      setState(() {
        _nameController.text = profileDoc['name'] ?? user?.displayName ?? '';
        _phoneController.text = profileDoc['phone'] ?? '';
        _addressController.text = profileDoc['address'] ?? '';
        _selectedGender = profileDoc['gender'] ?? '';
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('profiles')
        .doc('profile') // Assuming a single profile document
        .set({
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
    final primaryColor = Colors.green.shade600; // Align with grocery theme
    final accentColor = Colors.white;
    final inputFieldColor = Colors.green.shade50;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://www.gravatar.com/avatar/placeholder?d=mp'),
              backgroundColor: Colors.green.shade200,
            ),
            SizedBox(height: 16),
            Text(
              user?.email ?? 'No email available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 24),
            _buildProfileSection(
                'Name', _nameController, primaryColor, inputFieldColor),
            _buildProfileSection(
                'Phone', _phoneController, primaryColor, inputFieldColor,
                isPhone: true),
            _buildGenderDropdown(primaryColor, inputFieldColor),
            _buildProfileSection(
                'Address', _addressController, primaryColor, inputFieldColor),
            SizedBox(height: 24),
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
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Edit Profile',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String label, TextEditingController controller,
      Color borderColor, Color backgroundColor,
      {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: borderColor),
          fillColor: backgroundColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        enabled: isEditing,
      ),
    );
  }

  Widget _buildGenderDropdown(Color borderColor, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: borderColor),
          fillColor: backgroundColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
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
