class JobModel{
  final String? jobId;
  final String? jobTitle;
  final String? companyName;
  final String? address;
  final String? salary;
  final String? applicationLink;
  final String? description;
  final String? requirements;
  final String? benefits;
  final String? deadline;
  final String? openingTime;
  final String? closingTime;
  final bool isApplicable;
  final int? openingCount;
  final String? createdAt;

  JobModel({
     this.jobTitle,
     this.companyName,
     this.address,
     this.salary,
     this.applicationLink,
     this.description,
     this.requirements,
     this.benefits,
     this.deadline,
     this.openingTime,
     this.closingTime,
     this.isApplicable = true,
     this.openingCount,
     this.createdAt,
     this.jobId,
    });

   factory JobModel.fromJson(Map<String,dynamic> json){
     return JobModel(
       jobTitle: json['job_title'] ?? "",
       companyName: json['company'] ?? "",
       address: json['address'] ?? "",
       salary: json['salary'] ?? "",
       applicationLink: json['application_link'] ?? "",
       description: json['description'] ?? "",
       requirements: json['requirements'] ??  "",
       benefits: json['benefits'] ?? "",
       deadline: json['deadline']  ?? "",
       openingTime: json['opening_time'] ?? "",
       closingTime: json['closing_time'] ?? "",
       isApplicable: json['is_applicable'] ?? true,
       openingCount: json['opening_count'] ?? 10,
       createdAt: json['created_at'] ?? "",
       jobId: json['id'] ?? "",

     );
   }

   Map<String,dynamic> toJson (){
     return {
       'job_title': jobTitle,
       'company': companyName,
       'address': address,
       'salary': salary,
       'application_link': applicationLink,
       'description': description,
       'requirements': requirements,
       'benefits': benefits,
       'deadline': deadline,
       'opening_time': openingTime,
       'closing_time': closingTime,
       'is_applicable': isApplicable,
       'opening_count': openingCount,
       'created_at': createdAt,
       'id': jobId,
     };
   }
}