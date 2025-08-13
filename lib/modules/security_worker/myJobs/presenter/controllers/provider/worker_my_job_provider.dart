import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/utils.dart';
import '../../../infra/models/saved_job_model.dart';

class WorkerMyJobProvider extends ChangeNotifier{
  bool isLoading = false;
  bool isSavedJobLoading = false;
  int savedIndex = -1;
  List<SavedJobModel> _savedJobData = [];
  List<SavedJobModel> _appliedJobData = [];
  String? _applyingJobId;


  String? get applyingJobId => _applyingJobId;
  List<SavedJobModel>  get savedJobData => _savedJobData;
  List<SavedJobModel>  get appliedJobData => _appliedJobData;


  bool isApplying({required String jobId}){
   return _applyingJobId == jobId;
  }

  Future<void> init()async{
    await fetchSavedJobData();
    await fetchAppliedJobData();
  }

  void update(){
    notifyListeners();
  }

  ///  This method is used for fetching saved job data
  Future<void> fetchSavedJobData() async {
    try {
      isSavedJobLoading = true;
      notifyListeners();

      final resp = await SupabaseManager.supabaseClient
          .from('user_saved_job')
          .select('*, job(*), user_profile(*)')
          .eq('user_id', SupabaseManager.user!.id);

      if (resp.isNotEmpty) {
        _savedJobData = resp
            .map((e) => SavedJobModel.fromJson(e))
            .toList();
        debugPrint("All Saved Job Data fetch Successfully: ${_savedJobData.length}");
      } else {
        debugPrint("No Saved Job Data Found $resp");
        _savedJobData = [];
      }
    } catch (ex, st) {
      debugPrint("Error while fetching saved job data: $ex\n$st");
    } finally {
      isSavedJobLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAppliedJobData() async {
    try {
           isLoading = true;
           notifyListeners();
      final resp = await SupabaseManager.supabaseClient
          .from('user_applied_job')
          .select('*, job(*), user_profile(*)')
          .eq('user_id', SupabaseManager.user!.id);

      if (resp.isNotEmpty) {
        _appliedJobData = resp
            .map((e) => SavedJobModel.fromJson(e))
            .toList();
        debugPrint("All Applied Job Data fetch Successfully: ${_appliedJobData.length}");
      } else {
        debugPrint("No Applied Job Data Found $resp");
        _appliedJobData = [];
      }
    } catch (ex, st) {
      _appliedJobData = [];
      debugPrint("Error while fetching Applied job data: $ex\n$st");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// This method is used for save job
  Future<void> saveJob({required String jobId})async{
    final userId = SupabaseManager.user!.id;
    try{
      final jobResponse = await SupabaseManager.supabaseClient.from("user_saved_job").upsert({
        "job_id" : jobId,
        "user_id" : userId,
      },onConflict: "job_id").select();

      if(jobResponse!=null && jobResponse.isNotEmpty){
        Utils.showToast(msg: "Job Saved Successfully");
      }else{
        Utils.showToast(msg: "Job Saved Failed");
      }
    }catch (ex){
      debugPrint("Error while saving job data: $ex");
    }finally{
      await fetchSavedJobData();
      notifyListeners();
    }
  }

  ///this method is used for applying job
  Future<void> applyJob({required String jobId})async {
    if (_applyingJobId != null) return;
     _applyingJobId = jobId;
     notifyListeners();

    final userId = SupabaseManager.user!.id;
    try{
      final jobResponse = await SupabaseManager.supabaseClient.from("user_applied_job").upsert({
        "applied_job_id" : jobId,
        "user_id" : userId,
      },onConflict: "applied_job_id").select();

      if(jobResponse!=null && jobResponse.isNotEmpty){
        debugPrint("Job applied successfully $jobResponse");
      }else{
        debugPrint("Job applied failed $jobResponse");
      }
    }catch (ex){
      debugPrint("Error while applying job data: $ex");
    }finally{
      _applyingJobId = null;
      await fetchAppliedJobData();
    }
  }


  /// This method is used to remove applied job
  Future<void> removeAppliedJob({required String jobId})async{
    try{
       await SupabaseManager.supabaseClient.from("user_applied_job").delete().eq("user_id", SupabaseManager.user!.id).eq("applied_job_id", jobId);
     }catch (ex){
       debugPrint("Exception occurred while removing  job: $ex");
    }finally{
      fetchAppliedJobData();
      notifyListeners();
    }
  }


  /// This method is used to remove saved job
  Future<void> removeSavedJob({required String jobId})async{
    try{
      await SupabaseManager.supabaseClient.from("user_saved_job").delete().eq("user_id", SupabaseManager.user!.id).eq("job_id", jobId);
    }catch (ex){
      debugPrint("Exception occurred while removing  job: $ex");
    }finally{
      fetchSavedJobData();
      notifyListeners();
    }
  }


  /// This method is used to check job already saved or not
  bool checkJobSaved({required String jobId}){
    if(_savedJobData.isNotEmpty){
     return  _savedJobData.any((element) => element.jobId == jobId);
    }else{
      return false;
    }
  }

  /// This method is used to check job already applied or not
  bool checkJobApplied({required String jobId}){
    if(_appliedJobData.isNotEmpty){
      return  _appliedJobData.any((element) {
        return  element.job!.jobId == jobId;
      });
    }else{
      return false;
    }
  }
}
