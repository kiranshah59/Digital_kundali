import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../../payment/bloc/payment_bloc.dart';
import '../../payment/bloc/payment_event.dart';

class EsewaPaymentScreen extends StatefulWidget {
  final String actionUrl;
  final Map<String, dynamic> fields;

  const EsewaPaymentScreen({
    super.key,
    required this.actionUrl,
    required this.fields,
  });

  @override
  State<EsewaPaymentScreen> createState() => _EsewaPaymentScreenState();
}

class _EsewaPaymentScreenState extends State<EsewaPaymentScreen> {
  late final WebViewController _controller;

  // IMPORTANT: Set to false for production. The backend MUST return a unique transaction_uuid!
  final bool _useTestPayload = false;

  void _injectFormAndSubmit(String actionUrl, Map<String, dynamic> fields) {
    String formHtml = '<form id="esewa_form" action="$actionUrl" method="POST">';
    for (var entry in fields.entries) {
      formHtml += '<input type="hidden" name="${entry.key}" value="${entry.value}" />';
    }
    formHtml += '</form>';

    String js = '''
      document.body.innerHTML = `$formHtml`;
      document.getElementById("esewa_form").submit();
    ''';
    
    _controller.runJavaScript(js);
  }

  @override
  void initState() {
    super.initState();

    String actionUrl = widget.actionUrl;
    Map<String, dynamic> fields = widget.fields;

    if (_useTestPayload) {
      // 100% Valid eSewa Test Credentials to bypass backend's Duplicate UUID error
      final String transactionUuid = 'test_dk_${DateTime.now().millisecondsSinceEpoch}';
      final String totalAmount = '100';
      final String productCode = 'EPAYTEST';
      final String secretKey = '8gBm/:&EnhH.1/q';
      final String messageToSign = 'total_amount=$totalAmount,transaction_uuid=$transactionUuid,product_code=$productCode';
      
      var hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
      var digest = hmacSha256.convert(utf8.encode(messageToSign));
      String signature = base64Encode(digest.bytes);

      fields = {
        'amount': '100',
        'tax_amount': '0',
        'total_amount': '100',
        'transaction_uuid': transactionUuid,
        'product_code': 'EPAYTEST',
        'product_service_charge': '0',
        'product_delivery_charge': '0',
        'success_url': 'https://google.com/success',
        'failure_url': 'https://google.com/failure',
        'signed_field_names': 'total_amount,transaction_uuid,product_code',
        'signature': signature,
      };
      actionUrl = 'https://rc-epay.esewa.com.np/api/epay/main/v2/form';
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.startsWith('https://example.com')) {
              _injectFormAndSubmit(actionUrl, fields);
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load: ${error.description}')),
              );
              Navigator.of(context).pop(false);
            }
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            if (url.contains('/dashboard/payment/success') || url.contains('google.com/success')) {
              _handleSuccess();
            } else if (url.contains('/dashboard/payment/failure') || url.contains('google.com/failure')) {
              _handleFailure();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/dashboard/payment/success') || request.url.contains('google.com/success')) {
              _handleSuccess();
              return NavigationDecision.prevent;
            } else if (request.url.contains('/dashboard/payment/failure') || request.url.contains('google.com/failure')) {
              _handleFailure();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://example.com'));
  }

  bool _isNavigating = false;

  void _handleSuccess() {
    if (_isNavigating) return;
    _isNavigating = true;

    context.read<PaymentBloc>().add(LoadPlans());
    Navigator.of(context).pop(true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Your plan has been upgraded.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleFailure() {
    if (_isNavigating) return;
    _isNavigating = true;

    Navigator.of(context).pop(false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed or cancelled.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        title: const Text('eSewa Secure Payment', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
