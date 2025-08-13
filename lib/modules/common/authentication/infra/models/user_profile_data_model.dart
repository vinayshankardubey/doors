
class UserProfileDataModel{
  final String? name;
  final String? createdAt;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? licenseNumber;
  final String? dbsCertificateNumber;
  final String? driverLicenseNumber;
  final String? utrNumber;
  final bool isSupervisor;
  final String? latitude;
  final String? longitude;

  UserProfileDataModel({
    this.email,
    this.name,
    this.createdAt,
    this.phoneNumber,
    this.address,
    this.licenseNumber,
    this.dbsCertificateNumber,
    this.driverLicenseNumber,
    this.utrNumber,
    this.isSupervisor = false,
    this.latitude,
    this.longitude,
  });



  factory UserProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UserProfileDataModel(
      name: json['name']?? "",
      createdAt: json['created_at'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      address: json['address'] ?? "",
      licenseNumber: json['license_number'] ?? "",
      dbsCertificateNumber: json['dbs_certificate_number'] ?? "",
      driverLicenseNumber: json['driver_license_number'] ?? "",
      utrNumber: json['utr_number'] ?? "",
      isSupervisor:  json['is_supervisor'] ?? false,
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
    );

  }


  Map<String,dynamic> toJson(){
    return {
      "name" : name,
      "created_at" : createdAt,
      "email" : email,
      "phone_number" : phoneNumber,
      "address" : address,
      "license_number" : licenseNumber,
      "dbs_certificate_number" : dbsCertificateNumber,
      "driver_license_number" : driverLicenseNumber,
      "utr_number" : utrNumber,
      "is_supervisor" : isSupervisor,
      "latitude" : latitude,
      "longitude" : longitude,
    };
  }

}