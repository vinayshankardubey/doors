import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../core/utils.dart';
import '../../../../../security_worker/home/infra/models/job_model.dart';

class SupervisorHomeProvider extends ChangeNotifier{
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobDescController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  List<String> jobSectors = [
    "Security Services",
    "Event Management",
    "Logistics & Delivery",
    "Facility Management",
    "Retail Supervision",
    "Warehouse Operations",
    "Construction Labor",
    "Cleaning & Housekeeping",
    "Parking Management",
    "Bouncer / Crowd Control",
    "Industrial Security",
    "School / College Guard",
    "Reception / Front Desk",
    "Surveillance & CCTV",
    "Bank Security",
    "Hotel & Hospitality",
    "Cash Van Security",
    "Fire Safety Support",
    "Access Control Monitoring",
  ];

  bool isLoading = false;
  DateTime? selectedDate;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  String? selectedSector;

  void update(){
    notifyListeners();
  }


  /// This method is used to post job
  Future<void> postJob({required JobModel jobModel})async{
    try{
      isLoading = true;
      notifyListeners();
         final response = await SupabaseManager.supabaseClient.from("job").insert(jobModel.toJson()).select();
          if(response!=null && response.isNotEmpty){
            debugPrint("Job post successfully $response");
            Utils.showToast(msg: "Job post successfully");
            Utils.navigateBack();
            clearAllController();
          }else{
            debugPrint("Job post failed$response");
          }
    }catch (ex){
     debugPrint("Exception occurred while posting job:$ex");
     Utils.showToast(msg: "Something went wrong");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


  /// This method is used to clear all controller
  void clearAllController(){
    jobTitleController.clear();
    jobDescController.clear();
    salaryController.clear();
    locationController.clear();
    companyNameController.clear();
    selectedDate = null;
    openTime = null;
    closeTime = null;
    selectedSector = null;
  }

  Future<void> pickDate({required BuildContext context}) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );
    if (picked != null) {
       selectedDate = picked;
       notifyListeners();
    }
  }



}
