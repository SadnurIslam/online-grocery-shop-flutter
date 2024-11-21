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

  // Refresh the user state to update UI after login/logout
  void refreshUserState() {
    setState(() {});
  }

  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    refreshUserState();
  }

  Stream<List<Map<String, dynamic>>> fetchCategoriesStream() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    'name': doc['name'],
                  })
              .toList(),
        );
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
          'id': doc.id,
          ...data,
          'price': (data['price'] as num).toDouble(),
          'discountPrice': (data['discountPrice'] as num?)?.toDouble(),
        };
      }).toList();

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
            'FreshMart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[700],
          elevation: 2,
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey[100],
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
                decoration: BoxDecoration(
                  color: Colors.green[700],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.green[700]),
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              if (user != null)
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.green[700]),
                  title: Text('Favorites'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/favorites');
                  },
                ),
              if (user != null)
                ListTile(
                  leading: Icon(Icons.history, color: Colors.green[700]),
                  title: Text('Order History'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/orders');
                  },
                ),
              if (user != null)
                ListTile(
                  leading: Icon(Icons.support, color: Colors.green[700]),
                  title: Text('Live Chat'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/chat');
                  },
                ),
              if (user == null)
                ListTile(
                  leading: Icon(Icons.login, color: Colors.green[700]),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                ),
              if (user != null)
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.green[700]),
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
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.green[700]),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
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
                      padding: EdgeInsets.all(10.0),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          productId: product['id'],
                          productName: product['name'],
                          price: product['price'],
                          discountPrice: product['discountPrice'],
                          imageUrl: product['imageUrl'],
                          weight: product['weight'] ?? '1 kg',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNav(
          onCartTap: () {
            if (user == null) {
              Navigator.of(context).pushNamed('/login');
            } else {
              Navigator.of(context).pushNamed('/cart');
            }
          },
        ),
      ),
    );
  }
}
