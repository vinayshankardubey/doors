import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A custom text widget with default styling and optional overrides.
///
/// This widget provides a consistent text style across the application,
/// while allowing for customization of properties like [fontSize], [fontWeight],
/// [color], and [textAlign].
class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final TextStyle? textStyle;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = 14.0, // Default font size
    this.fontWeight = FontWeight.normal, // Default font weight
    this.color = Colors.black, // Default text color
    this.textAlign = TextAlign.start, // Default text alignment
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.decoration,
    this.fontStyle,
        this.textStyle,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle ?? TextStyle(
        fontSize: fontSize?.sp,
        fontWeight: fontWeight,
        color: color,
        height: height,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
    );
  }
}