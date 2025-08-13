import 'package:doors/core/utils.dart';
import 'package:doors/widgets/custom_animated_button.dart';
import 'package:doors/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constant/app_colors.dart';
import '../controllers/provider/worker_home_provider.dart';


 Future<void> jobFilterBottomSheet({required BuildContext context}) async {
   showModalBottomSheet(
     context: context,
     isScrollControlled: true,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
         topLeft: Radius.circular(10.r),
         topRight: Radius.circular(10.r),
       ),
     ),
     builder: (ctx) {
       return Padding(
         padding: EdgeInsets.only(
           bottom: MediaQuery.of(context).viewInsets.bottom,
         ),
         child: SingleChildScrollView(
           child: Container(
             width: 1.sw,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(10.r),
                 topRight: Radius.circular(10.r),
               ),
               color: AppColors.whiteColor,
             ),
             child: Consumer<WorkerHomeProvider>(
               builder: (context, workerHomeProvider, child) {
                 return Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     /// Header Row
                     Row(
                       children: [
                         CustomText(
                           'Filters',
                           textStyle: TextStyle(
                             fontSize: 18.sp,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Spacer(),
                         IconButton(
                           onPressed: () {
                             Utils.navigateBack();
                           },
                           icon: Icon(Icons.clear),
                         ),
                       ],
                     ).paddingOnly(
                       left: 15.w,
                       right: 15.w,
                       top: 10.h,
                       bottom: 10.h,
                     ),

                     Divider(height: 0),

                     /// Body Section (Row wrapped in fixed height)
                     SizedBox(
                       height: 320.h,
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           /// Left Side Filter Buttons
                           Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               _buildFilterFieldItem(
                                 title: "Sector",
                                 onTap: () => workerHomeProvider.setFilter("Sector"),
                                 ctx: ctx,
                                 isSelected:
                                 workerHomeProvider.selectedFilter == "Sector",
                               ),
                               _buildFilterFieldItem(
                                 title: "Distance",
                                 onTap: () => workerHomeProvider.setFilter("Distance"),
                                 ctx: ctx,
                                 isSelected:
                                 workerHomeProvider.selectedFilter == "Distance",
                               ),
                               _buildFilterFieldItem(
                                 title: "Date",
                                 onTap: () => workerHomeProvider.setFilter("Date"),
                                 ctx: ctx,
                                 isSelected:
                                 workerHomeProvider.selectedFilter == "Date",
                               ),
                             ],
                           ),

                           VerticalDivider(width: 0),

                           SizedBox(width: 10.w),

                           /// Right Side Filter Content
                           Expanded(
                             child: _buildFilteredItem(
                               title: workerHomeProvider.selectedFilter,
                               ctx: context,
                               workerHomeProvider: workerHomeProvider,
                             ),
                           ),
                         ],
                       ),
                     ),

                     /// Bottom Buttons
                     Material(
                       elevation: 1,
                       child: Container(
                         padding: EdgeInsets.symmetric(
                           vertical: 8.h,
                           horizontal: 10.w,
                         ),
                         decoration: BoxDecoration(
                           color: AppColors.whiteColor,
                         ),
                         child: Row(
                           children: [
                             Expanded(
                               child: SizedBox(
                                 height: 40.h,
                                 child: CustomAnimatedButton(
                                   borderRadius: BorderRadius.circular(10.r),
                                   backgroundColor: AppColors.secondaryColor,
                                   text: "Clear Filters",
                                   textStyle: TextStyle(
                                     fontWeight: FontWeight.w700,
                                     fontSize: 15.sp,
                                     color: AppColors.whiteColor,
                                   ),
                                   onPressed: () {
                                     workerHomeProvider.clearFilter();
                                   },
                                 ),
                               ),
                             ),
                             SizedBox(width: 10.w),
                             Expanded(
                               child: SizedBox(
                                 height: 40.h,
                                 child: CustomAnimatedButton(
                                   borderRadius: BorderRadius.circular(10.r),
                                   backgroundColor: AppColors.primaryColor,
                                   text: "Apply",
                                   textStyle: TextStyle(
                                     fontWeight: FontWeight.w700,
                                     fontSize: 15.sp,
                                     color: AppColors.whiteColor,
                                   ),
                                   onPressed: () {
                                     // Apply filter logic
                                   },
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 );
               },
             ),
           ),
         ),
       );
     },
   );
 }




 Widget _buildFilterFieldItem({required String title, VoidCallback? onTap,required BuildContext ctx , bool isSelected = false}){
   return Expanded(
     child: InkWell(
       onTap: onTap,
       child: Container(
         padding: EdgeInsets.only(left: 10.w),
        constraints: BoxConstraints(
        minWidth: MediaQuery.of(ctx).size.width * 0.25,
        ),
         alignment: Alignment.centerLeft,
           decoration: BoxDecoration(
             color:  isSelected ? AppColors.lightGreenColor : AppColors.whiteColor,
               border: Border(
                   bottom: BorderSide(color: AppColors.lightGreyColor,width: 1.w)
               )
           ),
           child: Center(child: CustomText(
             title,textStyle: TextStyle(fontSize: 16.sp),))
       ),
     ),
   );
 }

 Widget _buildFilteredItem({required String title, required BuildContext ctx, required WorkerHomeProvider workerHomeProvider}){
    switch (title){
      case "Sector":
         return Column(
           children: [
              Container(
                margin: EdgeInsets.only(top: 10.h,right: 10.w),
                width: MediaQuery.of(ctx).size.width*.75,
                child: TextFormField(
                  controller: workerHomeProvider.sectorController,
                 decoration: InputDecoration(
                   hintText: "Sector Name",
                   hintStyle: TextStyle(
                       color: AppColors.greyColor
                   ),
                   filled: true,
                   fillColor: AppColors.whiteColor,
                   enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.lightGreyColor)
                    ),
                   focusedBorder:  OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10.r),
                       borderSide: BorderSide(color: AppColors.lightGreyColor)
                   ),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10.r),
                     borderSide: BorderSide(color: AppColors.lightGreyColor)
                   ),
                 ),
                             ),
              ),
           ],
         );
      case "Distance":
        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h,right: 10.w),
              width: MediaQuery.of(ctx).size.width*.75,
              child: TextFormField(
                controller: workerHomeProvider.distanceController,
                decoration: InputDecoration(
                  hintText: "Distance in km",
                  hintStyle: TextStyle(
                      color: AppColors.greyColor
                  ),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColors.lightGreyColor)
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColors.lightGreyColor)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColors.lightGreyColor)
                  ),
                ),
              ),
            ),
          ],
        );
      case "Date":
        return Column(
          children: [
            InkWell(
              onTap: ()async{
              workerHomeProvider.startDate =  await showDatePicker(
                    context: ctx,
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime.now()
                );
              workerHomeProvider.update();
              },
              child: Container(
                margin: EdgeInsets.only(top: 10.h,right: 10.w),
                width: MediaQuery.of(ctx).size.width*.75,
                padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.lightGreyColor)
                ),
                child: Row(
                  children: [
                    CustomText(workerHomeProvider.startDate!=null ? workerHomeProvider.getDayMonthYear(date: workerHomeProvider.startDate!) : "Start date",color: AppColors.greyColor,),
                    Spacer(),
                    Icon(Icons.calendar_month,color: AppColors.greyColor,),

                  ],
                )
              ),
            ),
            InkWell(
              onTap: ()async{
                workerHomeProvider.endDate = await showDatePicker(
                    context: ctx,
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime.now()
                );
                workerHomeProvider.update();
              },
              child: Container(
                margin: EdgeInsets.only(top: 10.h,right: 10.w),
                width: MediaQuery.of(ctx).size.width*.75,
                padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.lightGreyColor)
                ),
                child: Row(
                  children: [
                    CustomText(workerHomeProvider.endDate!=null ? workerHomeProvider.getDayMonthYear(date: workerHomeProvider.endDate!) :"Last date",color: AppColors.greyColor,),
                    Spacer(),
                    Icon(Icons.calendar_month,color: AppColors.greyColor,),

                  ],
                )
              ),
            ),
          ],
        );
      default :
        return SizedBox();
    }
 }