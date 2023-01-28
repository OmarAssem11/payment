import 'package:flutter/material.dart';
import 'package:payment/api_manager/api_manager.dart';
import 'package:payment/screens/payment_screen.dart';

class RefCodeScreen extends StatelessWidget {
  static const String routeName = 'ref-code';

  const RefCodeScreen();

  @override
  Widget build(BuildContext context) {
    final paymentArgs =
        ModalRoute.of(context)!.settings.arguments! as PaymentArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ref Code'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: payWithRefCode(
            amount: paymentArgs.amount,
            billingData: paymentArgs.billingData,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong!');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final refCode = snapshot.data ?? '';
              return Text('Please go to pay with ref code: $refCode');
            }
          },
        ),
      ),
    );
  }
}
