import 'dart:convert';

import 'package:http/http.dart' as http;

class SendEmail {
  String userName;
  String message;
  SendEmail({required this.userName, required this.message});

  Future<void> forVerification() async {
    String serviceId = "service_0xudds5";
    String templateId = "template_62yqgrm";
    String userId = "m9Lf6LVqPwYcUh5G_";
    http.post(
      Uri.parse("https://api.emailjs.com/api/v1.0/email/send"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "user_name": userName,
          "message": message,
        },
      }),
    );
  }
}
