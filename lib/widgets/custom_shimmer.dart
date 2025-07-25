import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double height ;
  final double width ;
  final double radius ;
  final BoxShape? shape;
  const CustomShimmer({
    super.key,
    this.height = 50,
    this.width = 50,
    this.radius = 8,
    this.shape
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width.w,
          height: height.h,
          decoration: shape==null
          ? BoxDecoration(
            borderRadius: BorderRadius.circular(radius.r),
            color: Colors.white,
          )
          : BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
          )
          ,
        ),
      ),
    );
  }
}

