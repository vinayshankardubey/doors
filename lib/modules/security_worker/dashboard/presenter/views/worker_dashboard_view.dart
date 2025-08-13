import 'package:doors/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../home/presenter/views/worker_home_view.dart';
import '../../../myJobs/presenter/views/worker_my_job_view.dart';
import '../../../profile/presenter/views/worker_profile_view.dart';

class WorkerDashboardView extends StatefulWidget {
  const WorkerDashboardView({super.key});

  @override
  State<WorkerDashboardView> createState() => _WorkerDashboardViewState();
}

class _WorkerDashboardViewState extends State<WorkerDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkerHomeView(),
    WorkerMyJobView(),
    WorkerProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.sp),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // filled version on selection
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )

    );
  }
}
