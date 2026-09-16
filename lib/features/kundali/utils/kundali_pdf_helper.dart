import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/chart_service.dart';

class KundaliPdfHelper {
  static Future<void> generateAndDownloadPdf(BuildContext context, int profileId) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
              ),
              SizedBox(height: 16),
              Text(
                'Generating your full Kundali PDF...\nThis may take a few moments.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Step 1: Queue generation
      final response = await ChartService.generateKundaliPdf(profileId);
      if (!response['success']) {
        Navigator.pop(context); // Close dialog
        _showError(context, response['message'] ?? 'Failed to queue generation');
        return;
      }

      // Step 2: Poll status
      bool isReady = false;
      String? downloadUrl;
      int attempts = 0;
      const int maxAttempts = 60; // 60 * 3 = 180 seconds

      while (!isReady && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: 3));
        attempts++;

        if (!context.mounted) return;

        final pollResponse = await ChartService.pollKundaliPdfStatus(profileId);
        if (pollResponse['success']) {
          final decoded = pollResponse['data'];
          // Handle both wrapped and unwrapped responses
          final payload = (decoded is Map && decoded.containsKey('data') && decoded['data'] is Map) 
              ? decoded['data'] 
              : decoded;
              
          if (payload['status'] == 'completed') {
            isReady = true;
            downloadUrl = payload['download_url'];
          } else if (payload['status'] == 'failed') {
            Navigator.pop(context); // Close dialog
            _showError(context, 'PDF generation failed. Please try again later.');
            return;
          }
        } else {
          // If poll fails (e.g. network issue), we could stop or keep retrying. We will stop to be safe.
          Navigator.pop(context); // Close dialog
          _showError(context, pollResponse['message'] ?? 'Failed to check status');
          return;
        }
      }

      if (context.mounted) {
        Navigator.pop(context); // Close dialog
      }

      if (isReady && downloadUrl != null && downloadUrl.isNotEmpty) {
        // Open the URL
        final Uri url = Uri.parse(downloadUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            _showError(context, 'Could not open the PDF link.');
          }
        }
      } else {
        if (context.mounted) {
          _showError(context, 'Generation timed out. Please try again later.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close dialog
        _showError(context, 'An unexpected error occurred: $e');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
