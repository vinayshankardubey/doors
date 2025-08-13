import '../../../../common/authentication/infra/models/user_profile_data_model.dart';
import '../../../../supervisor/home/infra/models/job_model.dart';

class SavedJobModel {
  final String? id;
  final String? createdAt;
  final String? jobId;
  final String? userId;
  final JobModel? job;
  final String? status;
  final UserProfileDataModel? userProfile;

  SavedJobModel({
    this.id,
    this.createdAt,
    this.jobId,
    this.userId,
    this.job,
    this.userProfile,
    this.status,
  });

  factory SavedJobModel.fromJson(Map<String, dynamic> json) {
    // Safe casts
    final jobMap = json['job'];
    final userMap = json['user_profile'];

    return SavedJobModel(
      id: json['id'] ?? "",
      createdAt: json['created_at']  ?? "",
      jobId: json['job_id']  ?? "",
      userId: json['user_id']  ?? "",
      status: json["status"] ??  "",
      job: (jobMap is Map<String, dynamic>) ? JobModel.fromJson(jobMap) : null,
      userProfile: (userMap is Map<String, dynamic>)
          ? UserProfileDataModel.fromJson(userMap)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'job_id': jobId,
      'user_id': userId,
      'status': status,
      'job': job?.toJson(),
      'user_profile': userProfile?.toJson(),
    };
  }

}
