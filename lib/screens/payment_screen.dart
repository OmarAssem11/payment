import 'package:flutter/material.dart';
import 'package:payment/models/billing_data.dart';
import 'package:payment/screens/card_screen.dart';
import 'package:payment/screens/ref_code_screen.dart';
import 'package:payment/widgets/default_elevated_button.dart';
import 'package:payment/widgets/default_text_form_field.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/';

  const PaymentScreen();

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            right: 12,
            left: 12,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultTextFormField(
                  controller: _firstNameController,
                  hintText: 'First name',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 12),
                DefaultTextFormField(
                  controller: _lastNameController,
                  hintText: 'Last name',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 12),
                DefaultTextFormField(
                  controller: _emailController,
                  hintText: 'Email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                DefaultTextFormField(
                  controller: _phoneController,
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                DefaultTextFormField(
                  controller: _amountController,
                  hintText: 'Amount',
                  prefixIcon: Icons.money_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DefaultElevatedButton(
                        label: 'pay with card',
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            final paymentArgs = PaymentArguments(
                              amount: double.parse(_amountController.text),
                              billingData: BillingData(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                              ),
                            );
                            Navigator.of(context).pushNamed(
                              CardScreen.routeName,
                              arguments: paymentArgs,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DefaultElevatedButton(
                        label: 'pay with ref code',
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            final paymentArgs = PaymentArguments(
                              amount: double.parse(_amountController.text),
                              billingData: BillingData(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                              ),
                            );
                            Navigator.of(context).pushNamed(
                              RefCodeScreen.routeName,
                              arguments: paymentArgs,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

class PaymentArguments {
  final double amount;
  final BillingData billingData;

  const PaymentArguments({
    required this.amount,
    required this.billingData,
  });
}
