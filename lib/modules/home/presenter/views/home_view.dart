import 'package:doors/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../supabase/supabase_client.dart';
import '../../../../widgets/custom_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:  CustomText("Welcome 👋", textStyle: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              onPressed: (){
                SupabaseManager.logout(context);
              },
              icon: Icon(Icons.logout_outlined, color : AppColors.darkBlueColor,)
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔍 Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search for jobs...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🏷️ Job Categories
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip("All"),
                      _buildCategoryChip("Security"),
                      _buildCategoryChip("Concierge"),
                      _buildCategoryChip("Night Shift"),
                      _buildCategoryChip("Front Desk"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                CustomText(
                  "Recommended Jobs",
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                /// 📋 Job Listings
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (_, index) => _buildJobCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CustomText("Security Guard – Night Shift", textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            CustomText("XYZ Mall, Lucknow"),
            SizedBox(height: 6),
            CustomText("₹12,000/month | 8PM – 6AM"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: CustomText("Apply Now")),
                Icon(Icons.bookmark_border),
              ],
            )
          ],
        ),
      ),
    );
  }
}
