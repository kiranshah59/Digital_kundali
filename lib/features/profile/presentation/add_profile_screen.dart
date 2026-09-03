import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
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
          },
        ),
      );
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
          'Add New Profile',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ),
            );
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
                
                _buildInputField(
                  label: 'Full Name',
                  controller: _nameController,
                  hintText: 'e.g. Asha Sharma',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 20.h),
                
                _buildInputField(
                  label: 'Date of Birth (YYYY-MM-DD)',
                  controller: _dobController,
                  hintText: 'e.g. 1995-04-12',
                  icon: Icons.calendar_today_outlined,
                ),
                SizedBox(height: 20.h),
                
                _buildInputField(
                  label: 'Time of Birth (HH:MM)',
                  controller: _timeController,
                  hintText: 'e.g. 14:35',
                  icon: Icons.access_time,
                ),
                SizedBox(height: 20.h),
                
                _buildInputField(
                  label: 'Place of Birth',
                  controller: _locationController,
                  hintText: 'e.g. Bhaktapur, Nepal',
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: 40.h),
                
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF11141A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'SAVE PROFILE',
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: (value) => value!.isEmpty ? 'This field is required' : null,
          style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: const Color(0xFF8A8A8A), fontSize: 14.sp),
            prefixIcon: Icon(icon, color: const Color(0xFFA88143), size: 20.sp),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFFEAE6DF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFFEAE6DF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFFA88143), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
