import 'package:doors/core/constant/app_colors.dart';
import 'package:doors/modules/supervisor/home/presenter/views/supervisor_home_view.dart';
import 'package:doors/modules/supervisor/jobs/presenter/views/jobs_view.dart';
import 'package:doors/modules/supervisor/profile/presenter/views/supervisor_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SupervisorDashboardView extends StatefulWidget {
  const SupervisorDashboardView({super.key});

  @override
  State<SupervisorDashboardView> createState() => _SupervisorDashboardViewState();
}

class _SupervisorDashboardViewState extends State<SupervisorDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SupervisorHomeView(),
    JobsView(),
    SupervisorProfileView()
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
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'All Jobs',
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
