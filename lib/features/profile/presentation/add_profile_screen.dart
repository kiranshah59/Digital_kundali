import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali;
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../widgets/paid_plan_widget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';


class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();

  String _relationship = 'SELF';
  String _calendarSystem = 'AD';
  String _timePrecision = 'EXACT';

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _dobController.addListener(_validateForm);
    _timeController.addListener(_validateForm);
    _locationController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        _nameController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        _timeController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      String timeStr = _timeController.text.trim();
      if (timeStr.length > 5 && timeStr.contains(':')) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          timeStr = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      context.read<ProfileBloc>().add(
        AddProfile(
          profileData: {
            'full_name': _nameController.text.trim(),
            'date_of_birth': _dobController.text.trim(),
            'time_of_birth': timeStr,
            'birth_place_name': _locationController.text.trim(),
            'relationship': _relationship,
            'calendar_system': _calendarSystem,
            'time_precision': _timePrecision,
          },
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    if (_calendarSystem == 'BS') {
      nepali.NepaliDateTime? picked = await nepali.showMaterialDatePicker(
        context: context,
        initialDate: nepali.NepaliDateTime.now(),
        firstDate: nepali.NepaliDateTime(2000),
        lastDate: nepali.NepaliDateTime.now(),
      );
      if (picked != null) {
        setState(() {
          _dobController.text = nepali.NepaliDateFormat('yyyy-MM-dd').format(picked);
        });
      }
    } else {
      List<DateTime?>? results = await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          selectedDayHighlightColor: const Color(0xFF80CBC4),
        ),
        dialogSize: const Size(325, 400),
        value: [DateTime(2000, 1, 1)],
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF80CBC4),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (results != null && results.isNotEmpty && results[0] != null) {
        setState(() {
          _dobController.text = DateFormat('yyyy-MM-dd').format(results[0]!);
        });
      }
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF80CBC4),
              onPrimary: Colors.black,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF333333),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _timeController.text = DateFormat('HH:mm').format(dt);
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
          icon: Icon(Icons.arrow_back, color: const Color(0xFF11141A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Birth Profile',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            final isPlanError =
                state.message.toLowerCase().contains('plan') ||
                state.message.toLowerCase().contains('limit');
            if (isPlanError) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                builder: (context) =>
                    const PaidPlanWidget(featureName: 'Adding profiles'),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final bool _isLoading = state is ProfileLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('FULL NAME'),
                    _buildNewTextField(
                      controller: _nameController,
                      hintText: 'Aditi Sharma',
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('RELATIONSHIP'),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildPill(
                          'SELF',
                          _relationship == 'SELF',
                          () => setState(() => _relationship = 'SELF'),
                        ),
                        _buildPill(
                          'SPOUSE',
                          _relationship == 'SPOUSE',
                          () => setState(() => _relationship = 'SPOUSE'),
                        ),
                        _buildPill(
                          'CHILD',
                          _relationship == 'CHILD',
                          () => setState(() => _relationship = 'CHILD'),
                        ),
                        _buildPill(
                          'PARENT',
                          _relationship == 'PARENT',
                          () => setState(() => _relationship = 'PARENT'),
                        ),
                        _buildPill(
                          'SIBLING',
                          _relationship == 'SIBLING',
                          () => setState(() => _relationship = 'SIBLING'),
                        ),
                        _buildPill(
                          'OTHER',
                          _relationship == 'OTHER',
                          () => setState(() => _relationship = 'OTHER'),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('CALENDAR SYSTEM'),
                    Row(
                      children: [
                        _buildPill(
                          'AD',
                          _calendarSystem == 'AD',
                          () => setState(() => _calendarSystem = 'AD'),
                        ),
                        SizedBox(width: 8.w),
                        _buildPill(
                          'BS',
                          _calendarSystem == 'BS',
                          () => setState(() => _calendarSystem = 'BS'),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('DATE OF BIRTH (GREGORIAN)'),
                    _buildNewTextField(
                      controller: _dobController,
                      hintText: '1999-12-31',
                      trailingIcon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('TIME OF BIRTH PRECISION'),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildPill(
                          'EXACT',
                          _timePrecision == 'EXACT',
                          () => setState(() => _timePrecision = 'EXACT'),
                        ),
                        _buildPill(
                          'APPROXIMATE',
                          _timePrecision == 'APPROXIMATE',
                          () => setState(() => _timePrecision = 'APPROXIMATE'),
                        ),
                        _buildPill(
                          'UNKNOWN',
                          _timePrecision == 'UNKNOWN',
                          () => setState(() => _timePrecision = 'UNKNOWN'),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('TIME OF BIRTH'),
                    _buildNewTextField(
                      controller: _timeController,
                      hintText: 'Select a time',
                      trailingIcon: Icons.access_time,
                      readOnly: true,
                      onTap: _selectTime,
                    ),
                    SizedBox(height: 24.h),

                    _buildSectionLabel('BIRTH PLACE'),
                    _buildNewTextField(
                      controller: _locationController,
                      hintText: 'Search for a city...',
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "My city isn't listed — enter details manually",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFA88143),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? const Color(0xFF11141A)
                              : const Color(0xFF7F7F7F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'CREATE PROFILE',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: const Color(0xFF11141A),
        ),
      ),
    );
  }

  Widget _buildPill(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A0A0C) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFEAE6DF),
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF11141A),
          ),
        ),
      ),
    );
  }

  Widget _buildNewTextField({
    required String hintText,
    required TextEditingController controller,
    IconData? trailingIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) => value!.isEmpty ? 'Required' : null,
      style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: const Color(0xFF8A8A8A), fontSize: 14.sp),
        suffixIcon: trailingIcon != null
            ? Icon(trailingIcon, color: const Color(0xFF11141A), size: 20.sp)
            : null,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: const Color(0xFFEAE6DF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: const Color(0xFFEAE6DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: const Color(0xFFA88143), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _dobController.removeListener(_validateForm);
    _timeController.removeListener(_validateForm);
    _locationController.removeListener(_validateForm);
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
