import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _processPayment() {
    // Add payment processing logic here
    String amount = _amountController.text;
    String cardNumber = _cardNumberController.text;
    String expiryDate = _expiryDateController.text;
    String cvv = _cvvController.text;

    // Validate inputs
    if (amount.isEmpty || cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Call your payment processing method here
    // For example: processPayment(amount, cardNumber, expiryDate, cvv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount:', style: TextStyle(fontSize: 18.sp)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter amount'),
            ),
            SizedBox(height: 16),
            Text('Card Number:', style: TextStyle(fontSize: 18.sp)),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter card number'),
            ),
            SizedBox(height: 16),
            Text('Expiry Date (MM/YY):', style: TextStyle(fontSize: 18.sp)),
            TextField(
              controller: _expiryDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(hintText: 'Enter expiry date'),
            ),
            SizedBox(height: 16),
            Text('CVV:', style: TextStyle(fontSize: 18.sp)),
            TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter CVV'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _processPayment,
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
// void _processPayment() async {
//   try {
//     // Replace with your actual payment details and logic
//     final paymentMethod = await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     );
//
//     // Process the payment with your backend
//     // For example: await yourBackendProcessPayment(paymentMethod);
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment failed: $e')),
//     );
//   }
// }
