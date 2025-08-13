import 'package:flutter/material.dart';

import '../../../../../core/constant/app_colors.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jobPosts = [
      {
        'title': 'Flutter Developer',
        'company': 'TechNova Solutions',
        'location': 'Bangalore, India',
        'postedDate': '2025-07-30',
      },
      {
        'title': 'Backend Engineer',
        'company': 'CodeOrbit Inc.',
        'location': 'Remote',
        'postedDate': '2025-07-28',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'PixelWings Studio',
        'location': 'Mumbai, India',
        'postedDate': '2025-07-25',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Job Posts', style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView.builder(
        itemCount: jobPosts.length,
        itemBuilder: (context, index) {
          final job = jobPosts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  job['title'] ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Company: ${job['company']}"),
                      Text("Location: ${job['location']}"),
                      Text("Posted: ${job['postedDate']}"),
                    ],
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle edit/delete
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

