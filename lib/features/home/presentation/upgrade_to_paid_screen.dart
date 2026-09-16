import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../payment/bloc/payment_bloc.dart';
import '../../payment/bloc/payment_state.dart';
import '../../payment/data/payment_service.dart';
import '../../payment/presentation/esewa_payment_screen.dart';

class UpgradeToPaidScreen extends StatelessWidget {
  const UpgradeToPaidScreen({super.key});

  String _buildFeatureDescription(Map<String, dynamic>? plan) {
    if (plan == null) return 'Unlock all premium features.';
    
    int limit = plan['profile_limit'] ?? 20;
    List<String> features = [];
    
    final map = plan['features'];
    if (map != null && map is Map) {
       if (map['topic_insights'] == true) features.add('topic insights');
       if (map['dasha_analysis'] == true && map['dosha_detection'] == true) {
         features.add('Dasha & Dosha analysis');
       } else if (map['dasha_analysis'] == true) {
         features.add('Dasha analysis');
       } else if (map['dosha_detection'] == true) {
         features.add('Dosha detection');
       }
       if (map['diamond_kundali_detail'] == true) features.add('the Nepali kundali detail view');
       if (map['naming_assistant'] == true) features.add('the newborn naming assistant');
       if (map['guru_ai_chat'] == true) features.add('full AI Guru chat');
    }
    
    if (features.isEmpty) return 'Up to $limit birth profiles and more premium features.';
    
    String featureString;
    if (features.length == 1) {
      featureString = features.first;
    } else if (features.length == 2) {
      featureString = '${features[0]} and ${features[1]}';
    } else {
      final last = features.removeLast();
      featureString = '${features.join(', ')}, and $last';
    }
    
    return 'Up to $limit birth profiles, $featureString.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF11141A), size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Upgrade to Paid',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20.sp,
            color: const Color(0xFF11141A),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withAlpha(51), // roughly 0.2 opacity
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            Map<String, dynamic>? paidPlan;
            if (state is PaymentLoaded) {
              paidPlan = state.plans['paid'];
            }

            String priceStr = paidPlan?['price'] ?? 'NPR 251/mo';
            List<String> parts = priceStr.split('/');
            String amount = parts.isNotEmpty ? parts[0] : 'NPR 251';
            String freq = parts.length > 1 ? '/${parts[1]}' : '/monthly';
            if (freq == '/mo') freq = '/monthly';

            String description = _buildFeatureDescription(paidPlan);

            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF9F5),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFA88143),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UNLOCK EVERYTHING',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: const Color(0xFFA88143),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              amount,
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF11141A),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                freq,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            height: 1.5,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _EsewaButton(amount: amount),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EsewaButton extends StatefulWidget {
  final String amount;
  const _EsewaButton({required this.amount});

  @override
  State<_EsewaButton> createState() => _EsewaButtonState();
}

class _EsewaButtonState extends State<_EsewaButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isProcessing ? null : () async {
        setState(() { isProcessing = true; });
        
        final response = await PaymentService.initiateEsewaPayment();
        
        setState(() { isProcessing = false; });
        
        if (response['success'] && context.mounted) {
          if (response['action_url'] == null || response['fields'] == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid payment data received from server.')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EsewaPaymentScreen(
                actionUrl: response['action_url'],
                fields: response['fields'],
              ),
            ),
          ).then((success) {
            if (success == true && context.mounted) {
              Navigator.pop(context); // Close the upgrade screen on success
            }
          });
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to initiate payment')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A0A0C), // Dark blackish
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
      child: isProcessing 
        ? const SizedBox(
            width: 20, 
            height: 20, 
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
          )
        : Text(
            'PAY WITH ESEWA — ${widget.amount}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
    );
  }
}

