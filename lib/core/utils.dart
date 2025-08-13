import 'dart:developer';

import 'package:doors/core/routes/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constant/app_colors.dart';


/// Extension methods for [Widget] to easily apply padding.
extension WidgetPaddingX on Widget {
  /// Applies symmetric horizontal padding to the widget.
  Widget paddingSymmetricH(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget defaultPaddingH() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: this,
    );
  }

  Widget defaultPaddingHLeft() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: this,
    );
  }
  /// Applies symmetric vertical padding to the widget.
  Widget paddingSymmetricV(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }/// Applies symmetric vertical padding to the widget.
  Widget paddingSymmetric({required double h,required double v,}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: h,vertical: v),
      child: this,
    );
  }

  /// Applies padding to all sides of the widget.
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Applies padding only to the left side of the widget.
  Widget paddingLeft(double value) {
    return Padding(
      padding: EdgeInsets.only(left: value),
      child: this,
    );
  }

  /// Applies padding only to the right side of the widget.
  Widget paddingRight(double value) {
    return Padding(
      padding: EdgeInsets.only(right: value),
      child: this,
    );
  }

  /// Applies padding only to the top side of the widget.
  Widget paddingTop(double value) {
    return Padding(
      padding: EdgeInsets.only(top: value),
      child: this,
    );
  }

  /// Applies padding only to the bottom side of the widget.
  Widget paddingBottom(double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: value),
      child: this,
    );
  }

  /// Applies custom padding to the widget.
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }


}


/// Provides easy access to [MediaQuery] data for the current screen.
class ScreenUtils {
  static MediaQueryData of(BuildContext context) {
    return MediaQuery.of(context);
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static EdgeInsets viewInsets(BuildContext context) {
    return MediaQuery.of(context).viewInsets;
  }

  static EdgeInsets viewPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding;
  }

  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double systemGestureInsets(BuildContext context) {
    return MediaQuery.of(context).systemGestureInsets.bottom;
  }
}

class Utils{
  static double get horizontal => 10.w;
  static double get vertical => 16.h;
  static EdgeInsets get all => EdgeInsets.all(10.w);
  static EdgeInsets get symmetric => EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h);
  static EdgeInsets get horizontalOnly => EdgeInsets.symmetric(horizontal: 10.w);

  static void logD(dynamic message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      log('$tag: ${message.toString()}');
    }
  }

  static void logI(dynamic message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      log('$tag: $message');
    }
  }

  static void logW(dynamic message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      log('$tag ⚠️: $message');
    }
  }

  static void logE(dynamic message, {String tag = 'ERROR', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      log('$tag ❌: $message', error: error, stackTrace: stackTrace);
    }
  }

  static void navigateBack() {
    if (appRouter.canPop()) {
      appRouter.pop();
    }
  }

  static void navigateTo(String routeName, {Function? onReturn}) {
    Future.microtask(() {
      appRouter.push(routeName).then((_) {
        if (onReturn != null) onReturn();
      });
    });
  }

  static void navigateToOffAll(String routeName) {
    Future.microtask(() {
      while (appRouter.canPop()) {
        appRouter.pop();
      }
      appRouter.go(routeName);
    });
  }

  static void navigateToWithData(String routeName, Object? data) {
    Future.microtask(() {
      appRouter.push(routeName, extra: data);
    });
  }

  static showToast({required String msg}){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor.withOpacity(.8),
        textColor: AppColors.whiteColor,
        fontSize: 16.0
    );
  }
}