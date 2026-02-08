import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/text_style/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.enabled = true,
    this.lableLeft,
    this.styleLableLeft,
    this.hintStyle,
    this.lableRight,
    this.errorText,
    this.hintText,
    required this.controller,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.inputDecoration,
    this.decorationContainer,
    this.heightContainer,
    this.cursorColor,
    this.enableColor,
    this.onTap,
    this.focusNode,
    this.obscureText = false,
    this.autocorrect = true,
    this.readOnly,
    this.onChanged,
    this.style,
    this.onSubmit,
    this.maxLength,
    this.inputFormatters,
    this.expands = false,
    this.autofocus = false,
    this.textInputAction,
    this.fillColor,
    this.keyTextField,
    this.floatingLabelBehavior,
    this.counterText,
    this.filled,
    this.contentPadding,
    this.suffix,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixStyle,
    this.suffixText,
    this.prefix,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixStyle,
    this.prefixText,
    required this.isError,
    this.needRequired = false,
    this.onTapOutSide,
    this.autoValidateMode,
    this.isShowCounter = false,
    this.borderRadius,
  });

  final bool enabled;
  final String? lableLeft;
  final TextStyle? styleLableLeft;
  final TextStyle? hintStyle;
  final Widget? lableRight;
  final String? errorText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? inputDecoration;
  final BoxDecoration? decorationContainer;
  final double? heightContainer;
  final Color? cursorColor;
  final Color? enableColor;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool autocorrect;
  final bool? readOnly;
  final void Function(String)? onChanged;
  final TextStyle? style;
  final void Function(String)? onSubmit;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool expands;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Key? keyTextField;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? counterText;
  final bool? filled;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final TextStyle? suffixStyle;
  final String? suffixText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final TextStyle? prefixStyle;
  final String? prefixText;
  final bool isError;
  final bool needRequired;
  final Function? onTapOutSide;
  final AutovalidateMode? autoValidateMode;
  final bool? isShowCounter;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lableLeft != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          lableLeft ?? '',
                          style:
                              styleLableLeft ??
                              TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (needRequired)
                        Text(
                          " *",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red5,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  lableRight ?? const SizedBox(),
                ],
              ),
            if (lableLeft != null) SizedBox(height: 8.w),
          ],
        ),
        Container(
          height: heightContainer,
          decoration:
              decorationContainer ??
              BoxDecoration(
                color: enableColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
          child: TextFormField(
            key: keyTextField,
            textInputAction: textInputAction,
            autofocus: autofocus,
            onFieldSubmitted: onSubmit,
            maxLength: maxLength,
            expands: expands,
            inputFormatters:
                inputFormatters ?? [LengthLimitingTextInputFormatter(2000)],
            style: style ?? AppTextStyles.textStyle14,
            onTap: onTap,
            focusNode: focusNode,
            obscureText: obscureText,
            autocorrect: autocorrect,
            enabled: enabled,
            onChanged: onChanged,

            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
              if (onTapOutSide != null) {
                onTapOutSide!();
              }
            },
            readOnly: readOnly ?? false,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: minLines,
            cursorColor: cursorColor,
            autovalidateMode: autoValidateMode,
            decoration:
                inputDecoration ??
                InputDecoration(
                  suffix: suffix,
                  suffixIcon: suffixIcon,
                  suffixIconColor: suffixIconColor,
                  suffixStyle: suffixStyle,
                  suffixText: suffixText,
                  prefix: prefix,
                  prefixIcon: prefixIcon,
                  prefixIconColor: prefixIconColor,
                  prefixStyle: prefixStyle,
                  prefixText: prefixText,
                  filled: filled,
                  fillColor: fillColor,
                  counterText: counterText,
                  floatingLabelBehavior: floatingLabelBehavior,
                  contentPadding:
                      contentPadding ??
                      EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
                    borderSide: BorderSide(
                      color: isError ? AppColors.red5 : AppColors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
                    borderSide: BorderSide(
                      color: isError ? AppColors.red5 : AppColors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
                    borderSide: BorderSide(
                      color: isError ? AppColors.red5 : AppColors.grey,
                    ),
                  ),
                  hintText: hintText,
                  hintStyle: hintStyle,
                ),
          ),
        ),
        if (isError && errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.w),
            child: Text(
              errorText!,
              style: AppTextStyles.textStyle11.copyWith(color: AppColors.red5),
            ),
          ),
      ],
    );
  }
}
