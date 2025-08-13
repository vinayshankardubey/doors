import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../supabase/supabase_client.dart';
import '../../../../common/authentication/infra/models/user_profile_data_model.dart';


class ProfileProvider extends ChangeNotifier {

  UserProfileDataModel? userProfileData ;




  Future<void> fetchUserProfileData() async {
    try{
        final userResponse = await SupabaseManager.supabaseClient
                                     .from("user_profile").select()
                                     .eq("user_id", SupabaseManager.user!.id).maybeSingle();

        if(userResponse!=null && userResponse.isNotEmpty){
          userProfileData = UserProfileDataModel.fromJson(userResponse);
          debugPrint("User Profile data fetch successfully $userResponse");
        }else{
          debugPrint("User Profile data not found $userResponse");
        }
    } on AuthException{
      debugPrint("No internet or host unreachable");
    }catch (ex){
       debugPrint("Exception occurred while fetching user profile data $ex");
    }finally{
      notifyListeners();
    }
  }

}