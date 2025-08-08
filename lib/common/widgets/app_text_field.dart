import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? helperText;
  void Function(String?)? onSaved;
  String? Function(String?)? validator;

  AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.helperText,
    this.onSaved,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
       TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon != null
                ? Container(
                    margin: EdgeInsets.only(left: 16.w, right: 12.w),
                    child: Icon(
                      prefixIcon,
                      size: 20.sp,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Container(
                    margin: EdgeInsets.only(right: 16.w),
                    child: suffixIcon,
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border, width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.error, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.error, width: 2.w),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.5),
                width: 1.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            counterText: '',
          ),
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          enabled: enabled,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
          onSaved: onSaved,
        ),
        if (helperText != null) ...[
          SizedBox(height: 4.h),
          Text(
            helperText!,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

class AppTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? helperText;

  const AppTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLines = 5,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      helperText: helperText,
      textInputAction: TextInputAction.newline,
    );
  }
}
