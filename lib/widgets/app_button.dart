import 'package:flutter/material.dart';
import 'package:taskapp/constants/app_colors.dart';
import 'package:taskapp/constants/screen_size.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    this.onPressed,
    this.title,
  });

  final VoidCallback? onPressed;
  final String? title;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.fullWidth,
      height: 55,
      child: ElevatedButton(
        onPressed: widget.onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(
              15,
            ),
          ),
        ),

        child: Text(
          widget.title ?? 'title',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
