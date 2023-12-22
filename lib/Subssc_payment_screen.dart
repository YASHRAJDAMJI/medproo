import 'package:aashray_veriion3/UpiPaymentScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(SubPaymentScreen());

class SubPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SubscriptionScreen(),
    );
  }
}

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Add any necessary variables and logic for handling subscriptions

  void makePayment(double price, String recnm, String upid) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UpiPaymentScreen(price: price, recnm: recnm, upid: upid),
      ),
    );
    print('Payment of $price is initiated.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose a subscription plan:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic for handling the selected subscription plan
              },
              child: Text('Basic Plan - \$9.99/month'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add logic for handling the selected subscription plan
              },
              child: Text('Premium Plan - \$19.99/month'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double pr=800;

                makePayment(pr, '8856887702@ybl', 'Yashraj Damji');
              },
              child: Text('Pro Plan - \$29.99/month'),
            ),
          ],
        ),
      ),
    );
  }
}
