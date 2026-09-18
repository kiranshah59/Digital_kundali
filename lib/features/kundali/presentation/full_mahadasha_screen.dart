import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/upgrade_to_paid_banner.dart';
import '../data/chart_service.dart';

class FullMahadashaScreen extends StatefulWidget {
  final int profileId;

  const FullMahadashaScreen({super.key, required this.profileId});

  @override
  State<FullMahadashaScreen> createState() => _FullMahadashaScreenState();
}

class _FullMahadashaScreenState extends State<FullMahadashaScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _sequence = [];
  Map<String, dynamic>? _currentMahadasha;

  int? _statusCode;

  @override
  void initState() {
    super.initState();
    _fetchDashaData();
  }

  Future<void> _fetchDashaData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _statusCode = null;
    });

    final res = await ChartService.getDasha(widget.profileId);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _statusCode = res['statusCode'];
        if (res['success'] == true) {
          final data = res['data'] ?? {};
          _sequence = data['sequence'] ?? [];
          _currentMahadasha = data['current_mahadasha'];
        } else {
          _error = res['message'] ?? 'Failed to load Mahadasha timeline';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF11141A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mahadasha Timeline',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA88143)),
      );
    }

    if (_error != null) {
      if (_statusCode == 402) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: UpgradeToPaidBanner(),
          ),
        );
      }
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  color: const Color(0xFF11141A),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _fetchDashaData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11141A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: const Text('Try Again', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_sequence.isEmpty) {
      return const Center(
        child: Text('No Dasha sequence available.'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      itemCount: _sequence.length,
      itemBuilder: (context, index) {
        final period = _sequence[index];
        final lord = period['lord'] ?? 'Unknown';
        final isCurrent = _currentMahadasha != null && _currentMahadasha!['lord'] == lord;
        
        DateTime? startDate;
        DateTime? endDate;
        try {
          if (period['start_date'] != null) startDate = DateTime.parse(period['start_date']);
          if (period['end_date'] != null) endDate = DateTime.parse(period['end_date']);
        } catch (_) {}

        String dateRange = '';
        if (startDate != null && endDate != null) {
          dateRange = '${DateFormat('MMM yyyy').format(startDate)} - ${DateFormat('MMM yyyy').format(endDate)}';
        }

        return _buildTimelineItem(
          lord: lord,
          dateRange: dateRange,
          isCurrent: isCurrent,
          isLast: index == _sequence.length - 1,
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required String lord,
    required String dateRange,
    required bool isCurrent,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          Column(
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent ? const Color(0xFFA88143) : Colors.transparent,
                  border: Border.all(
                    color: isCurrent ? const Color(0xFFA88143) : const Color(0xFFD6D1C4),
                    width: 2,
                  ),
                ),
                child: isCurrent 
                    ? Icon(Icons.star, size: 10.sp, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: const Color(0xFFE8E5DF),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 24.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isCurrent ? const Color(0xFFF9F6F0) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isCurrent ? const Color(0xFFA88143) : const Color(0xFFE8E5DF),
                ),
                boxShadow: isCurrent ? [
                  BoxShadow(
                    color: const Color(0xFFA88143).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$lord Mahadasha',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isCurrent ? const Color(0xFF8B6420) : const Color(0xFF11141A),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA88143),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            'Active',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12.sp, color: const Color(0xFF8A8A8A)),
                      SizedBox(width: 6.w),
                      Text(
                        dateRange,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
