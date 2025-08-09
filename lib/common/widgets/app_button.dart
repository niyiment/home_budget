import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BorderSide? border;

  const AppButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return Container(
      width: width ?? double.infinity,
      height: height ?? 40.h,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : gradient ?? AppColors.primaryGradient,
        color: isDisabled ? AppColors.border : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        boxShadow: isDisabled
            ? null
            : boxShadow ??
                  [
                    BoxShadow(
                      color:
                          (gradient?.colors.first ??
                                  backgroundColor ??
                                  AppColors.primary)
                              .withValues(alpha: 0.3),
                      blurRadius: 12.r,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? Colors.white,
                      ),
                    ),
                  )
                else if (icon != null) ...[
                  Icon(icon, color: textColor ?? Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                if (!isLoading)
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDisabled
                          ? AppColors.textDisabled
                          : textColor ?? Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppButtonOutlined extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;

  const AppButtonOutlined({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      borderRadius: borderRadius,
      backgroundColor: Colors.transparent,
      textColor: textColor ?? AppColors.primary,
      gradient: null,
      border: BorderSide(color: borderColor ?? AppColors.primary, width: 1.5.w),
      boxShadow: [],
    );
  }
}

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: textColor ?? AppColors.primary,
                  size: (fontSize ?? 14.sp) + 2,
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: fontSize ?? 14.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: textColor ?? AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
