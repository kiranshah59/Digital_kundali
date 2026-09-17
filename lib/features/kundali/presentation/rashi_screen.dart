import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'insights_main_screen.dart';
import '../data/chart_service.dart';
import 'package:intl/intl.dart';
import '../../../widgets/upgrade_to_paid_banner.dart';

class RashiScreen extends StatefulWidget {
  final dynamic profileData;

  const RashiScreen({super.key, this.profileData});

  @override
  State<RashiScreen> createState() => _RashiScreenState();
}

class _RashiScreenState extends State<RashiScreen> {
  bool _isDetailed = false;
  bool _showEnglish = true;
  String _selectedTime = 'Today';

  Map<String, dynamic>? _dashaData;
  bool _isLoadingDasha = false;
  String? _dashaError;
  int? _dashaStatusCode;

  Map<String, dynamic>? _rashiData;
  bool _isLoadingRashi = false;
  String? _rashiError;

  Map<String, dynamic>? _doshaData;
  bool _isLoadingDosha = false;
  String? _doshaError;
  int? _doshaStatusCode;

  String _getFallbackDescription(String? slug) {
    if (slug == null) return '';
    switch (slug.toLowerCase()) {
      case 'mesha': case 'mesh': case 'aries':
        return 'As a Mesha (Aries) native, you are ruled by Mars, the planet of action and courage. You possess a natural drive to lead and pioneer new paths. Your personality is characterized by high energy, enthusiasm, and a bold approach to life\'s challenges.';
      case 'vrishabha': case 'vrishabh': case 'brishabh': case 'brish': case 'taurus':
        return 'As a Vrishabha (Taurus) native, you are ruled by Venus, the planet of beauty and comfort. You possess a grounded and practical nature, valuing stability and security. Your personality is characterized by patience, loyalty, and a strong appreciation for the finer things in life.';
      case 'mithuna': case 'mithun': case 'gemini':
        return 'As a Mithuna (Gemini) native, you are ruled by Mercury, the planet of communication and intellect. You possess a versatile and adaptable mind, always curious to learn. Your personality is characterized by quick wit, sociability, and a love for sharing ideas.';
      case 'karka': case 'karkat': case 'cancer':
        return 'As a Karka (Cancer) native, you are ruled by the Moon, representing emotions and intuition. You possess a deep sensitivity and a nurturing spirit, highly protective of loved ones. Your personality is characterized by empathy, strong family bonds, and emotional depth.';
      case 'simha': case 'singha': case 'singh': case 'leo':
        return 'As a Simha (Leo) native, you are ruled by the Sun, the source of life and vitality. You possess a natural charisma and a commanding presence that often places you in leadership positions. Your personality is characterized by a noble heart, immense creative energy, and a steadfast sense of loyalty.';
      case 'kanya': case 'virgo':
        return 'As a Kanya (Virgo) native, you are ruled by Mercury, emphasizing analysis and service. You possess a meticulous and analytical approach to life, always striving for perfection. Your personality is characterized by practicality, attention to detail, and a deep desire to help others.';
      case 'tula': case 'libra':
        return 'As a Tula (Libra) native, you are ruled by Venus, the planet of harmony and relationships. You possess a strong sense of fairness and a natural diplomatic ability. Your personality is characterized by a love for balance, artistic sensibilities, and a cooperative spirit.';
      case 'vrishchika': case 'vrishchik': case 'brishchik': case 'scorpio':
        return 'As a Vrishchika (Scorpio) native, you are ruled by Mars (and Pluto), signifying transformation and intensity. You possess a powerful and passionate nature, with a profound emotional depth. Your personality is characterized by resourcefulness, determination, and a magnetic presence.';
      case 'dhanu': case 'sagittarius':
        return 'As a Dhanu (Sagittarius) native, you are ruled by Jupiter, the planet of expansion and wisdom. You possess an adventurous and optimistic outlook, always seeking truth and meaning. Your personality is characterized by a love for freedom, philosophical thinking, and a jovial spirit.';
      case 'makara': case 'makar': case 'capricorn':
        return 'As a Makara (Capricorn) native, you are ruled by Saturn, the planet of discipline and structure. You possess a strong work ethic and a serious, ambitious nature. Your personality is characterized by responsibility, practicality, and a steadfast determination to achieve your goals.';
      case 'kumbha': case 'kumbh': case 'aquarius':
        return 'As a Kumbha (Aquarius) native, you are ruled by Saturn (and Uranus), focusing on innovation and humanitarianism. You possess an independent and unconventional mindset, often ahead of your time. Your personality is characterized by intellectual originality, social consciousness, and a strong sense of individuality.';
      case 'meena': case 'meen': case 'pisces':
        return 'As a Meena (Pisces) native, you are ruled by Jupiter (and Neptune), highlighting empathy and spirituality. You possess a compassionate and imaginative soul, deeply connected to the unseen world. Your personality is characterized by artistic talent, intuition, and a profound emotional understanding.';
      default:
        return 'No detailed description is currently available for this Rashi.';
    }
  }

  String? _getFallbackElement(String? slug) {
    if (slug == null) return null;
    switch (slug.toLowerCase()) {
      case 'mesha': case 'mesh': case 'aries':
      case 'simha': case 'singha': case 'singh': case 'leo':
      case 'dhanu': case 'sagittarius':
        return 'Fire';
      case 'vrishabha': case 'vrishabh': case 'brishabh': case 'brish': case 'taurus':
      case 'kanya': case 'virgo':
      case 'makara': case 'makar': case 'capricorn':
        return 'Earth';
      case 'mithuna': case 'mithun': case 'gemini':
      case 'tula': case 'libra':
      case 'kumbha': case 'kumbh': case 'aquarius':
        return 'Air';
      case 'karka': case 'karkat': case 'cancer':
      case 'vrishchika': case 'vrishchik': case 'brishchik': case 'scorpio':
      case 'meena': case 'meen': case 'pisces':
        return 'Water';
      default:
        return null;
    }
  }

  String? _getFallbackModality(String? slug) {
    if (slug == null) return null;
    switch (slug.toLowerCase()) {
      case 'mesha': case 'mesh': case 'aries':
      case 'karka': case 'karkat': case 'cancer':
      case 'tula': case 'libra':
      case 'makara': case 'makar': case 'capricorn':
        return 'Cardinal';
      case 'vrishabha': case 'vrishabh': case 'brishabh': case 'brish': case 'taurus':
      case 'simha': case 'singha': case 'singh': case 'leo':
      case 'vrishchika': case 'vrishchik': case 'brishchik': case 'scorpio':
      case 'kumbha': case 'kumbh': case 'aquarius':
        return 'Fixed';
      case 'mithuna': case 'mithun': case 'gemini':
      case 'kanya': case 'virgo':
      case 'dhanu': case 'sagittarius':
      case 'meena': case 'meen': case 'pisces':
        return 'Mutable';
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    _fetchDashaData();
    _fetchRashiData();
    _fetchDoshaData();
  }

  Future<void> _fetchRashiData() async {
    final profileId = widget.profileData?['id'];
    if (profileId == null) return;
    setState(() {
      _isLoadingRashi = true;
      _rashiError = null;
    });
    final res = await ChartService.getRashi(profileId);
    if (mounted) {
      if (res['success']) {
        final rashiData = res['data'];
        final slug = rashiData['slug'];
        if (slug != null) {
          final detailsRes = await ChartService.getRashiDetails(slug);
          if (detailsRes['success'] && mounted) {
            setState(() {
              _isLoadingRashi = false;
              _rashiData = {
                ...rashiData,
                ...detailsRes['data'],
              };
            });
            return;
          }
        }
        setState(() {
          _isLoadingRashi = false;
          _rashiData = rashiData;
        });
      } else {
        setState(() {
          _isLoadingRashi = false;
          _rashiError = res['message'];
        });
      }
    }
  }

  Future<void> _fetchDoshaData() async {
    final profileId = widget.profileData?['id'];
    if (profileId == null) return;
    setState(() {
      _isLoadingDosha = true;
      _doshaError = null;
      _doshaStatusCode = null;
    });
    final lang = _showEnglish ? 'en' : 'ne';
    final style = _isDetailed ? 'technical' : 'simple';
    final res = await ChartService.getDoshaFlags(profileId, language: lang, style: style);
    if (mounted) {
      setState(() {
        _isLoadingDosha = false;
        if (res['success']) {
          _doshaData = res['data'];
        } else {
          _doshaError = res['message'];
          _doshaStatusCode = res['statusCode'];
        }
      });
    }
  }

  Future<void> _fetchDashaData() async {
    final profileId = widget.profileData?['id'];
    if (profileId == null) return;

    setState(() {
      _isLoadingDasha = true;
      _dashaError = null;
      _dashaStatusCode = null;
    });

    final lang = _showEnglish ? 'en' : 'ne';
    final style = _isDetailed ? 'technical' : 'simple';

    final res = await ChartService.getDasha(
      profileId,
      language: lang,
      style: style,
    );

    if (mounted) {
      setState(() {
        _isLoadingDasha = false;
        if (res['success']) {
          _dashaData = res['data'];
        } else {
          _dashaError = res['message'];
          _dashaStatusCode = res['statusCode'];
        }
      });
    }
  }

  void _onToggleLanguage(bool isEnglish) {
    if (_showEnglish != isEnglish) {
      setState(() {
        _showEnglish = isEnglish;
      });
      _fetchDashaData();
      _fetchDoshaData();
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = widget.profileData?['full_name'] ?? 'Unknown User';

    // Get initials
    final List<String> nameParts = fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    String initials = 'U';
    if (nameParts.isNotEmpty) {
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        initials = nameParts[0].length >= 2
            ? nameParts[0].substring(0, 2).toUpperCase()
            : nameParts[0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context) ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: Text(
          fullName,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundColor: const Color(0xFF11141A),
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEAE6DF))),
              ),
              child: Row(
                children: [
                  SizedBox(width: 24.w),
                  _buildTopTab('Charts', false, () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }),
                  SizedBox(width: 24.w),
                  _buildTopTab('Insights', false, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InsightsMainScreen(),
                      ),
                    );
                  }),
                  SizedBox(width: 24.w),
                  _buildTopTab('Rashi', true, () {}),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Icon
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard,
                  color: const Color(0xFFA88143),
                  size: 36.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            if (_isLoadingRashi)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: const CircularProgressIndicator(color: Color(0xFFA88143)),
              )
            else if (_rashiError != null)
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(_rashiError!, style: TextStyle(color: Colors.red)),
              )
            else if (_rashiData != null) ...[
              Text(
                '${_rashiData!['name_sanskrit']} (${_rashiData!['name_en']})',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              if (_rashiData!['ruling_planet'] != null) ...[
                SizedBox(height: 8.h),
                Text(
                  'RULING PLANET: ${_rashiData!['ruling_planet']}'.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: const Color(0xFFA88143),
                  ),
                ),
              ],
            ],
            SizedBox(height: 32.h),

            // Time Toggles
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F5F2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    _buildTimeToggle('Today'),
                    _buildTimeToggle('Week'),
                    _buildTimeToggle('Month'),
                    _buildTimeToggle('Year'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Settings Toggles
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Simple / Detailed Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        _buildToggle(
                          'Simple',
                          !_isDetailed,
                          () => setState(() => _isDetailed = false),
                        ),
                        _buildToggle(
                          'Detailed',
                          _isDetailed,
                          () => setState(() => _isDetailed = true),
                        ),
                      ],
                    ),
                  ),
                  // EN / NE Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        _buildToggle(
                          'EN',
                          _showEnglish,
                          () => setState(() => _showEnglish = true),
                        ),
                        _buildToggle(
                          'NE',
                          !_showEnglish,
                          () => setState(() => _showEnglish = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // About Section
            if (_rashiData != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About ${_rashiData!['name_sanskrit']} (${_rashiData!['name_en']})',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAE6DF),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          _buildMiniToggle('EN', true),
                          _buildMiniToggle('NE', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFEAE6DF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFallbackDescription(_rashiData!['slug']),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          color: const Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),
                      if (_rashiData!['element'] != null || _getFallbackElement(_rashiData!['slug']) != null || _rashiData!['modality'] != null || _getFallbackModality(_rashiData!['slug']) != null) ...[
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            if (_rashiData!['element'] != null || _getFallbackElement(_rashiData!['slug']) != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCF4E6),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '${_rashiData!['element'] ?? _getFallbackElement(_rashiData!['slug'])} SIGN'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFA88143),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            if (_rashiData!['modality'] != null || _getFallbackModality(_rashiData!['slug']) != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E2433),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '${_rashiData!['modality'] ?? _getFallbackModality(_rashiData!['slug'])} MODALITY'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],

            // Current Dasha Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Dasha',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        _buildMiniToggle(
                          'EN',
                          _showEnglish,
                          onTap: () => _onToggleLanguage(true),
                        ),
                        _buildMiniToggle(
                          'NE',
                          !_showEnglish,
                          onTap: () => _onToggleLanguage(false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (_isLoadingDasha)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFA88143),
                  ),
                ),
              )
            else if (_dashaError != null)
              if (_dashaStatusCode == 402)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: UpgradeToPaidBanner(),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.withAlpha(75)),
                    ),
                    child: Text(
                      _dashaError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
            else if (_dashaData != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFEAE6DF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MAHADASHA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${_dashaData?['current_mahadasha']?['lord'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 18.sp,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.stars,
                            color: const Color(0xFFA88143),
                            size: 24.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Stack(
                        children: [
                          Container(
                            height: 4.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAE6DF),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          Container(
                            height: 4.h,
                            width: 200.w, // Progress indicator
                            decoration: BoxDecoration(
                              color: const Color(0xFFA88143),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ANTARDASHA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${_dashaData?['current_antardasha']?['lord'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Ends on',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(
                                  _dashaData?['current_antardasha']?['end_date'] ??
                                      '',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_dashaData?['explanation']?['content'] != null) ...[
                        SizedBox(height: 24.h),
                        Divider(color: const Color(0xFFEAE6DF)),
                        SizedBox(height: 16.h),
                        Text(
                          _dashaData!['explanation']['content'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            color: const Color(0xFF475569),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            SizedBox(height: 32.h),

            // Dosha Check Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'Dosha Check',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (_isLoadingDosha)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFA88143),
                  ),
                ),
              )
            else if (_doshaError != null)
              if (_doshaStatusCode == 402)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: UpgradeToPaidBanner(),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.withAlpha(75)),
                    ),
                    child: Text(
                      _doshaError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
            else if (_doshaData != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildDoshaCard(
                  'Mangal Dosha',
                  _doshaData!['mangal_dosha']?['severity'] ?? 'Not Active',
                  _doshaData!['mangal_dosha']?['present'] == true,
                  _doshaData!['mangal_dosha']?['present'] == true,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildDoshaCard(
                  'Shani (Sade Sati)',
                  _doshaData!['shani_sade_sati']?['severity'] ?? 'Not Active',
                  _doshaData!['shani_sade_sati']?['present'] == true,
                  _doshaData!['shani_sade_sati']?['present'] == true,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildDoshaCard(
                  'Kaal Sarp Dosha',
                  _doshaData!['kaal_sarp_dosha']?['severity'] ?? 'No Dosha Found',
                  _doshaData!['kaal_sarp_dosha']?['present'] == true,
                  _doshaData!['kaal_sarp_dosha']?['present'] == true,
                ),
              ),
            ],
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTab(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF0F172A) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeToggle(String text) {
    bool isActive = text == _selectedTime;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTime = text),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0A0A0C) : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniToggle(String text, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildDoshaCard(
    String title,
    String subtitle,
    bool hasDosha,
    bool showRemedies,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: hasDosha
                      ? const Color(0xFFFFF5F5)
                      : const Color(0xFFF8F9FA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    hasDosha ? Icons.emergency : Icons.check_circle_outline,
                    color: hasDosha
                        ? const Color(0xFFD35555)
                        : const Color(0xFFD4AF37),
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      color: hasDosha
                          ? const Color(0xFFD35555)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showRemedies)
            Text(
              'Remedies',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA88143),
              ),
            ),
        ],
      ),
    );
  }
}
