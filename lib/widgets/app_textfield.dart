import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:taskapp/constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.hasError,
    this.keyboardType,
    this.isPassword = false,
    this.enabled,
    this.bottomPadding,
    this.validator,
    this.formatters,
  });

  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final double? bottomPadding;
  final List<TextInputFormatter>? formatters;
  final bool? hasError;
  final bool? enabled;
  final FormFieldValidator? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding ?? 0,
      ),
      child: TextFormField(
        controller: widget.controller,

        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        validator: widget.validator,

        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        maxLines: 1,
        expands: false,

        inputFormatters: widget.formatters,

        decoration: InputDecoration(
          hintMaxLines: 1,

          prefixIcon: widget.prefixIcon,
          prefixIconColor: Color(0xFF797979),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            color: Color(0xFF797979),
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: AppColor.accent1,
              // color: AppColor.color79,
            ),
            borderRadius: BorderRadius.circular(15),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
