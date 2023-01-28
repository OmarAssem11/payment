import 'package:flutter/material.dart';
import 'package:payment/screens/card_screen.dart';
import 'package:payment/screens/payment_screen.dart';
import 'package:payment/screens/ref_code_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        PaymentScreen.routeName: (_) => const PaymentScreen(),
        CardScreen.routeName: (_) => const CardScreen(),
        RefCodeScreen.routeName: (_) => const RefCodeScreen(),
      },
    );
  }
}
