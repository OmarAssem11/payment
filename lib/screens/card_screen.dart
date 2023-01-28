import 'package:flutter/material.dart';
import 'package:payment/api_manager/api_manager.dart';
import 'package:payment/constants/constants.dart';
import 'package:payment/screens/payment_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardScreen extends StatefulWidget {
  static const String routeName = 'card';

  const CardScreen();

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final _webViewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    final paymentArgs =
        ModalRoute.of(context)!.settings.arguments! as PaymentArguments;
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: payWithCard(
            amount: paymentArgs.amount,
            billingData: paymentArgs.billingData,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong!');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final paymentToken = snapshot.data ?? '';
              _webViewController
                ..loadRequest(Uri.parse(iframeUrl + paymentToken))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate());
              return WebViewWidget(
                controller: _webViewController,
              );
            }
          },
        ),
      ),
    );
  }
}
