import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/cupertino.dart';
import '../../../infra/models/job_model.dart';

class WorkerHomeProvider extends ChangeNotifier{
   TextEditingController sectorController = TextEditingController();
   TextEditingController distanceController = TextEditingController();
   DateTime? startDate ;
   DateTime? endDate ;
   String _selectedFilter = "";
   bool isLoading = false;

   List<JobModel> _allJobData = [];



   List<JobModel> get allJobData => _allJobData;
   String get selectedFilter => _selectedFilter;

   void init ()async{
    await fetchJobData();
   }

   void update(){
     notifyListeners();
   }

   /// apply filter
   void setFilter(String filter){
     _selectedFilter = filter;
     notifyListeners();
   }

  /// fetch job data
   Future<void> fetchJobData() async{
     try{
         isLoading= true;
         notifyListeners();
       final jobResponse = await SupabaseManager.supabaseClient.from("job").select();
        if(jobResponse!=null && jobResponse.isNotEmpty){
           _allJobData = jobResponse.map((e) => JobModel.fromJson(e)).toList();
           debugPrint("All Job Data fetch Successfully: ${_allJobData.length}");
        }else{
          debugPrint("No Job Data Found $jobResponse");
        }
     }catch (ex){
       debugPrint("Error while fetching job data: $ex");
     }finally{
       isLoading = false;
       notifyListeners();
     }
     
   }


   String getDayMonthYear({required DateTime date}){
     final String day = date.day.toString().padLeft(2, '0');
     final String month = date.month.toString().padLeft(2, '0');
     return "$day-$month-${date.year}";
   }

   void clearFilter(){
     _selectedFilter = "";
     startDate = null;
     endDate = null;
     notifyListeners();
   }
}
