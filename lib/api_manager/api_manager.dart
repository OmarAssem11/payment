import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:payment/constants/constants.dart';
import 'package:payment/models/billing_data.dart';

late String _paymentAuthToken;

Future<void> _getPaymentAuthToken() async {
  final uri = Uri.https(baseUrl, '/api/auth/tokens');
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"api_key": apiKey}),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  _paymentAuthToken = json['token'] as String;
}

Future<String> _getPaymentOrderId(double amount) async {
  final uri = Uri.https(baseUrl, '/api/ecommerce/orders');
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "auth_token": _paymentAuthToken,
      "delivery_needed": "false",
      "amount_cents": "$amount",
      "currency": "EGP",
      "items": [],
    }),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return json['id'].toString();
}

Future<String> _getPaymentKeyToken({
  required double amount,
  required String orderId,
  required BillingData billingData,
  required int integrationId,
}) async {
  final uri = Uri.https(baseUrl, '/api/acceptance/payment_keys');
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "auth_token": _paymentAuthToken,
      "amount_cents": "$amount",
      "order_id": orderId,
      "billing_data": {
        "first_name": "first",
        "last_name": "last",
        "email": "user@test.com",
        "phone_number": "01234567899",
        "apartment": "NA",
        "floor": "NA",
        "building": "NA",
        "street": "NA",
        "postal_code": "NA",
        "city": "NA",
        "state": "NA",
        "country": "NA",
        "shipping_method": "NA",
      },
      "currency": "EGP",
      "expiration": 3600,
      "integration_id": integrationId,
    }),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return json['token'] as String;
}

Future<String> _getRefCode(String paymentKeyToken) async {
  final uri = Uri.https(baseUrl, '/api/acceptance/payments/pay');
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "source": {
        "identifier": "AGGREGATOR",
        "subtype": "AGGREGATOR",
      },
      "payment_token": paymentKeyToken,
    }),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return json['id'].toString();
}

Future<String> payWithCard({
  required double amount,
  required BillingData billingData,
}) async {
  try {
    await _getPaymentAuthToken();
    final orderId = await _getPaymentOrderId(amount);
    final paymentKeyToken = await _getPaymentKeyToken(
      amount: amount,
      orderId: orderId,
      billingData: billingData,
      integrationId: cardIntegrationId,
    );
    return paymentKeyToken;
  } catch (error) {
    rethrow;
  }
}

Future<String> payWithRefCode({
  required double amount,
  required BillingData billingData,
}) async {
  try {
    await _getPaymentAuthToken();
    final orderId = await _getPaymentOrderId(amount);
    final paymentKeyToken = await _getPaymentKeyToken(
      amount: amount,
      orderId: orderId,
      billingData: billingData,
      integrationId: kioskIntegrationId,
    );
    final refCode = await _getRefCode(paymentKeyToken);
    return refCode;
  } catch (error) {
    rethrow;
  }
}
