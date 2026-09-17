import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/naming_cubit.dart';
import '../../data/models.dart';

class BabyNameCard extends StatelessWidget {
  final BabyName babyName;

  const BabyNameCard({super.key, required this.babyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      babyName.name,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF11141A),
                      ),
                    ),
                    if (babyName.nameDevanagari.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        babyName.nameDevanagari,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Row(
                children: [
                  _ReactionButton(
                    icon: Icons.thumb_up_alt_outlined,
                    activeIcon: Icons.thumb_up,
                    count: babyName.likesCount,
                    isActive: babyName.reaction == 'like',
                    onTap: () {
                      context.read<NamingCubit>().toggleReaction(babyName.id, 'like');
                    },
                  ),
                  SizedBox(width: 12.w),
                  _ReactionButton(
                    icon: Icons.thumb_down_alt_outlined,
                    activeIcon: Icons.thumb_down,
                    count: babyName.dislikesCount,
                    isActive: babyName.reaction == 'dislike',
                    onTap: () {
                      context.read<NamingCubit>().toggleReaction(babyName.id, 'dislike');
                    },
                  ),
                ],
              ),
            ],
          ),
          if (babyName.meaning != null && babyName.meaning!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              babyName.meaning!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: const Color(0xFF4A4A4A),
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              if (babyName.gender != null)
                _buildTag(babyName.gender!.toUpperCase()),
              if (babyName.origin != null) ...[
                if (babyName.gender != null) SizedBox(width: 8.w),
                _buildTag(babyName.origin!.toUpperCase()),
              ],
              const Spacer(),
              if (babyName.source == 'ai')
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 14.sp, color: const Color(0xFFA88143)),
                    SizedBox(width: 4.w),
                    Text(
                      'AI Generated',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA88143),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0EA),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF11141A),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.icon,
    required this.activeIcon,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 20.sp,
            color: isActive ? const Color(0xFFA88143) : const Color(0xFF8A8A8A),
          ),
          if (count > 0) ...[
            SizedBox(width: 4.w),
            Text(
              count.toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFFA88143) : const Color(0xFF8A8A8A),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
