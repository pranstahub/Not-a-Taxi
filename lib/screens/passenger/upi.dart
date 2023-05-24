/*import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  sendMoneyToPaytmWallet("your_upi_id", "your_paytm_wallet", 100.0);
}

void sendMoneyToPaytmWallet(
    String senderUPIId, String paytmWallet, double amount) async {
  // Replace with your actual UPI payment API endpoint
  var upiApiUrl = "https://your-upi-payment-api-endpoint.com/upi/payment";

  // Replace with your actual Paytm API endpoint
  var paytmApiUrl = "https://your-paytm-api-endpoint.com/paytm/payment";

  var headers = {"Content-Type": "application/json"};

  var payload = {
    "sender_upi_id": senderUPIId,
    "paytm_wallet": paytmWallet,
    "amount": amount
  };

  var body = jsonEncode(payload);

  try {
    // Make UPI payment
    var upiResponse = await http.post(Uri.parse(upiApiUrl),
        headers: headers, body: body);

    if (upiResponse.statusCode == 200) {
      // UPI payment successful
      print("UPI payment successful!");

      // Transfer funds to Paytm wallet
      var paytmResponse = await http.post(Uri.parse(paytmApiUrl),
          headers: headers, body: body);

      if (paytmResponse.statusCode == 200) {
        // Payment to Paytm wallet successful
        print("Payment to Paytm wallet successful!");
      } else {
        // Payment to Paytm wallet failed
        print("Payment to Paytm wallet failed: ${paytmResponse.statusCode}");
      }
    } else {
      // UPI payment failed
      print("UPI payment failed: ${upiResponse.statusCode}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}*/
