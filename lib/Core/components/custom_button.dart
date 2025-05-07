import 'package:flutter/material.dart';
import 'media_query.dart';
import '../styles/color_manager.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? verticalPadding;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final Widget? icon;
  final double? horizontalPadding;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorManager.primaryColor,
    this.textColor = Colors.white,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderRadius = 15.0,
    this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.width = double.infinity,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey[300] : backgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? mq.height(2),
            horizontal: horizontalPadding ?? 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  SizedBox(width: mq.width(2)),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize ?? mq.width(4),
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize ?? mq.width(4),
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
