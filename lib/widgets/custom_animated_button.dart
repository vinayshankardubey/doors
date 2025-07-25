import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text.dart';

/// A custom animated button widget.
///
/// This button provides a customizable text, background color, text color,
/// and an optional animation on tap.
class CustomAnimatedButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final Widget? preWidget;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final bool? isFullWidth; // NEW


  const CustomAnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    this.borderRadius,
    this.textStyle,
    this.isFullWidth,
    this.preWidget,
    this.isLoading = false

  });

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButton2State();
}

class _CustomAnimatedButton2State extends State<CustomAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _startAnimation() {
    _controller.forward().then((onValue){
      _reverseAnimation();
      if(widget.onPressed != null){
        widget.onPressed.call();
      }

    });
  }

  void _reverseAnimation() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _startAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: (widget.isFullWidth ==  true) ? double.infinity : null,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(100.r),
          ),
          child: Center(
            child:  widget.isLoading ?  CircularProgressIndicator(color: widget.textColor,)
            : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 if(widget.preWidget !=null) ...[
                   widget.preWidget!,
                    SizedBox(width: 8.w),
                 ]else ...[SizedBox()],
                CustomText(
                  widget.text,
                  color: widget.textColor,
                  fontSize: widget.fontSize!.sp,
                  fontWeight: widget.fontWeight,
                  textStyle: widget.textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}