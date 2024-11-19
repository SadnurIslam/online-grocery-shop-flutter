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
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported, size: 50);
          },
        ),
      ),
      title: Text(method),
      trailing: selectedPaymentMethod == method
          ? Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Please select your mode of Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildPaymentOption(
                  'Bkash',
                  'https://ahkhan.com/wp-content/uploads/2018/07/Bkash-Customer-Care1.png',
                ),
                _buildPaymentOption(
                  'Nagad',
                  'https://upload.wikimedia.org/wikipedia/en/thumb/8/88/Nagad_Logo_2024.svg/220px-Nagad_Logo_2024.svg.png',
                ),
                _buildPaymentOption(
                  'Rocket',
                  'https://futurestartup.b-cdn.net/wp-content/uploads/2016/09/DBBL-Mobile-Banking-Becomes-Rocket.jpg',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: ৳${widget.totalPrice}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: selectedPaymentMethod == 'Bkash'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BkashAccountPage(
                                  totalPrice: widget.totalPrice),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('PROCEED TO PAYMENT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
