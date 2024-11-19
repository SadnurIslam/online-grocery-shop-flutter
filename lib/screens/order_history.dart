import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchOrderHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .get();

    return ordersSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'products': data['products'] ?? [],
        'totalPrice': data['totalPrice'] ?? 0.0,
        'paymentMethod': data['paymentMethod'] ?? 'Unknown',
        'status': data['status'] ?? 'Unknown',
        'timestamp': data['timestamp'],
      };
    }).toList();
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown Date';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching orders.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final products = order['products'] as List;
              final totalPrice = order['totalPrice'];
              final paymentMethod = order['paymentMethod'];
              final status = order['status'];
              final timestamp = order['timestamp'];

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date: ${_formatDate(timestamp)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total: ৳$totalPrice',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Payment: $paymentMethod',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              status == 'Confirmed' ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      Text(
                        'Products:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      ...products.map<Widget>((product) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(
                            product['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product['name'],
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            '${product['quantity']} x ৳${product['discountPrice']}',
                          ),
                          trailing: Text(
                            '৳${product['quantity'] * product['discountPrice']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
