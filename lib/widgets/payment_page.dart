import 'package:flutter/material.dart';
import 'package:newapp/payments/bkash_account.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  PaymentPage({required this.totalPrice});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;

  Widget _buildPaymentOption(String method, String imageUrl) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported, size: 50);
            },
          ),
        ),
        title: Text(
          method,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: selectedPaymentMethod == method
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            selectedPaymentMethod = method;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Please select your preferred Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // Payment Method List
            child: ListView(
              children: [
                _buildPaymentOption(
                  'Bkash',
                  'https://ahkhan.com/wp-content/uploads/2018/07/Bkash-Customer-Care1.png',
                ),
                _buildPaymentOption(
                  'Nagad',
                  'https://finclusion.sg/wp-content/uploads/2020/12/nagad-logo.png',
                ),
                _buildPaymentOption(
                  'Rocket',
                  'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh9MGrnY31hCji4jMRyJfPWA3cff1b6fIQSB32whxH49-In7B17iDATl0-8nynH1AjJm0SN-fbv6Qitpdzvqw1vjuanBUvNxGUBjD2_vuzB5RVRmC9YuYGL6609W7X_H5MOOEdJUh7pSRx0/w250-h320/dutch-bangla-rocket.jpg',
                ),
                _buildPaymentOption(
                  'Upay',
                  'https://scontent.fdac5-1.fna.fbcdn.net/v/t39.30808-6/363433112_611467534450220_6583966670615072957_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGIoCUh9J4rL-H64QXI6fE91-7HLvDLGcrX7scu8MsZykXfRDN9kUdgolgDA3tauf5pqWi2DEpsVg1dsTALzsB8&_nc_ohc=TDO4nOYDG5YQ7kNvgFfyse1&_nc_zt=23&_nc_ht=scontent.fdac5-1.fna&_nc_gid=AKIb8Nkf3qeV1MkpgvvzFPi&oh=00_AYDNo6xrc7uY1wMyEK9lgO7DoyyGRA10jMQpv2nLM__Edw&oe=674053A7',
                ),
                _buildPaymentOption(
                  'Cash on Delivery',
                  'https://miro.medium.com/v2/resize:fit:640/format:webp/1*5c8KOrF2CKKQCcY67sJDWA.jpeg',
                ),
              ],
            ),
          ),
          // Total Price & Proceed Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Total Price Display
                Text(
                  'Total: ৳${widget.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Proceed Button
                ElevatedButton(
                  onPressed: selectedPaymentMethod == 'Bkash'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BkashAccountPage(
                                totalPrice: widget.totalPrice,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Button color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'PROCEED TO PAYMENT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
