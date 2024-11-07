import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newapp/widgets/product_card.dart';
import 'package:newapp/widgets/category_chip.dart';
import 'package:newapp/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategoryId;
  TextEditingController searchController = TextEditingController();

  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Stream<List<Map<String, dynamic>>> fetchCategoriesStream() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchProductsStream() {
    String query = searchController.text.toLowerCase();

    final baseQuery = selectedCategoryId == null
        ? FirebaseFirestore.instance.collection('products')
        : FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: selectedCategoryId);

    return baseQuery.snapshots().map((snapshot) {
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'price': (data['price'] as num).toDouble(),
        };
      }).toList();

      // Apply search filter
      if (query.isNotEmpty) {
        return products
            .where((product) =>
                product['name'].toString().toLowerCase().contains(query))
            .toList();
      }
      return products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Grocery',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? 'Guest'),
                accountEmail: Text(user?.email ?? 'No email'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      user?.photoURL ?? 'https://via.placeholder.com/150'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.of(context).pushNamed('/favorites');
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Order History'),
                onTap: () {
                  Navigator.of(context).pushNamed('/orderHistory');
                },
              ),
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Contact Support'),
                onTap: () {
                  Navigator.of(context).pushNamed('/support');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await _signOut(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {}); // Trigger rebuild to update search
                },
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {}); // Clear search filter
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            // Category Chips StreamBuilder
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchCategoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No categories found'));
                } else {
                  final categories = snapshot.data!;
                  return SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryChip(
                          categoryName: 'Popular',
                          isSelected: selectedCategoryId == null,
                          onSelected: () {
                            setState(() {
                              selectedCategoryId = null;
                            });
                          },
                        ),
                        ...categories.map((category) => CategoryChip(
                              categoryName: category['name'],
                              isSelected: selectedCategoryId == category['id'],
                              onSelected: () {
                                setState(() {
                                  selectedCategoryId = category['id'];
                                });
                              },
                            )),
                      ],
                    ),
                  );
                }
              },
            ),
            // Product Grid StreamBuilder
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    final products = snapshot.data!;
                    return GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          productName: product['name'],
                          price: product['price'],
                          imageUrl: product['imageUrl'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
