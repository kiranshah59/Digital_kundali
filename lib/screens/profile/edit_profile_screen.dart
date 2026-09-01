import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic profileData;

  const EditProfileScreen({super.key, required this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profileData['full_name'] ?? '');
    _dobController = TextEditingController(text: widget.profileData['date_of_birth'] ?? '');
    
    String timeOfBirth = widget.profileData['time_of_birth'] ?? '';
    if (timeOfBirth.length > 5) {
      timeOfBirth = timeOfBirth.substring(0, 5); // Take only HH:mm
    }
    _timeController = TextEditingController(text: timeOfBirth);
    
    _locationController = TextEditingController(text: widget.profileData['place_of_birth'] ?? widget.profileData['birth_place_name'] ?? '');
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String timeStr = _timeController.text.trim();
      // Ensure HH:MM format
      if (timeStr.contains(':')) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          timeStr = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      int profileId = widget.profileData['id'];

      final response = await ProfileService.updateProfile(
        id: profileId,
        fullName: _nameController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
        timeOfBirth: timeStr,
        birthPlaceName: _locationController.text.trim(),
        originalProfile: Map<String, dynamic>.from(widget.profileData),
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, response['data']); // Return the updated data
        }
      } else {
        setState(() {
          _errorMessage = response['message'];
        });
      }
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
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                
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
                            'SAVE CHANGES',
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
