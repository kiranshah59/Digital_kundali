import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/presentation/upgrade_to_paid_screen.dart';
import '../../../widgets/paid_plan_widget.dart';
import '../bloc/naming_cubit.dart';
import '../bloc/naming_state.dart';
import 'widgets/baby_name_card.dart';

class NamingAssistantScreen extends StatefulWidget {
  final dynamic profileData;

  const NamingAssistantScreen({super.key, required this.profileData});

  @override
  State<NamingAssistantScreen> createState() => _NamingAssistantScreenState();
}

class _NamingAssistantScreenState extends State<NamingAssistantScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedGender;
  String? _selectedOrigin;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.profileData != null && widget.profileData['id'] != null) {
      context.read<NamingCubit>().loadInitialSuggestions(widget.profileData['id'].toString());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<NamingCubit>().loadMore();
    }
  }

  void _onFilterChanged() {
    context.read<NamingCubit>().applyFilter(
      gender: _selectedGender,
      origin: _selectedOrigin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF11141A),
                  size: 24.sp,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Naming Suggestions',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ),
      body: BlocBuilder<NamingCubit, NamingState>(
        builder: (context, state) {
          if (state is NamingPaymentRequired) {
            return const PaidPlanWidget(featureName: 'Naming Assistant');
          }
          
          if (state is NamingError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: const Color(0xFFD35555),
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        color: const Color(0xFF11141A),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NamingLoading && state.isFirstLoad) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFA88143)),
              ),
            );
          }

          if (state is NamingLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Text(
                        'Starting Sound:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070B19),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          state.startingSound,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFDE0AD),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFiltersRow(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    itemCount: state.names.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.names.length) {
                        return _buildListFooter(state);
                      }
                      return BabyNameCard(babyName: state.names[index]);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: _selectedGender,
              hint: 'Gender',
              items: const ['male', 'female', 'unisex'],
              onChanged: (val) {
                setState(() => _selectedGender = val);
                _onFilterChanged();
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildDropdown(
              value: _selectedOrigin,
              hint: 'Origin',
              items: const ['nepali', 'indian', 'both'],
              onChanged: (val) {
                setState(() => _selectedOrigin = val);
                _onFilterChanged();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: const Color(0xFF8A8A8A),
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 16.sp, color: const Color(0xFF11141A)),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'All',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  color: const Color(0xFF11141A),
                ),
              ),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildListFooter(NamingLoaded state) {
    if (state.isGeneratingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFA88143)),
          ),
        ),
      );
    }

    if (!state.pagination.hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {
              context.read<NamingCubit>().generateMoreNames();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D0F17),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 16.sp, color: const Color(0xFFFDE0AD)),
                SizedBox(width: 8.w),
                Text(
                  'Generate More Names (AI)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
