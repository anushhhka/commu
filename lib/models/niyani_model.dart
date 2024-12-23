import 'package:cloud_firestore/cloud_firestore.dart';

class NiyaniModel {
  String activityOrEmployeeStatus;
  int? additionalNumber;
  String bloodGroup;
  String? city;
  Timestamp? dateOfBirth;
  String education;
  String email;
  String? emailAddress;
  String fullNameOfMavitra;
  String fullNameOfTheMarriedDaughter;
  String hobbies;
  String? imagePath;
  bool isAdmin;
  bool isVerified;
  String? maritalStatus;
  Timestamp? marriageDate;
  int mobileOrWhatsappNumber;
  String? officeAddress;
  int pinCode;
  String residentialAddress;
  String state;
  Timestamp timestamp;
  int totalNumberOfFamilyMembers;
  String villageName;

  NiyaniModel({
    required this.activityOrEmployeeStatus,
    this.additionalNumber,
    required this.bloodGroup,
    this.city,
    this.dateOfBirth,
    required this.education,
    required this.email,
    this.emailAddress,
    required this.fullNameOfMavitra,
    required this.fullNameOfTheMarriedDaughter,
    required this.hobbies,
    this.imagePath,
    required this.isAdmin,
    required this.isVerified,
    this.maritalStatus,
    this.marriageDate,
    required this.mobileOrWhatsappNumber,
    this.officeAddress,
    required this.pinCode,
    required this.residentialAddress,
    required this.state,
    required this.timestamp,
    required this.totalNumberOfFamilyMembers,
    required this.villageName,
  });

  factory NiyaniModel.fromJson(Map<String, dynamic> json) {
    return NiyaniModel(
      activityOrEmployeeStatus: json['activityOrEmployeeStatus']?.toString() ?? '',
      additionalNumber: json['additionalNumber'] != null ? int.tryParse(json['additionalNumber'].toString()) : null,
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      city: json['city']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null ? (json['dateOfBirth'] as Timestamp) : null,
      education: json['education']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      emailAddress: json['emailAddress']?.toString(),
      fullNameOfMavitra: json['fullNameOfMavitra']?.toString() ?? '',
      fullNameOfTheMarriedDaughter: json['fullNameOfTheMarriedDaughter']?.toString() ?? '',
      hobbies: json['hobbies']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
      isAdmin: json['isAdmin'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      maritalStatus: json['maritalStatus']?.toString(),
      marriageDate: json['marriageDate'] != null ? (json['marriageDate'] as Timestamp) : null,
      mobileOrWhatsappNumber: int.tryParse(json['mobileOrWhatsappNumber'].toString()) ?? 0,
      officeAddress: json['officeAddress']?.toString(),
      pinCode: int.tryParse(json['pinCode'].toString()) ?? 0,
      residentialAddress: json['residentialAddress']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      timestamp: json['timestamp'] as Timestamp,
      totalNumberOfFamilyMembers: json['totalNumberOfFamilyMembers'] is int
          ? json['totalNumberOfFamilyMembers'] as int
          : int.tryParse(json['totalNumberOfFamilyMembers'].toString()) ?? 0,
      villageName: json['villageName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityOrEmployeeStatus': activityOrEmployeeStatus,
      'additionalNumber': additionalNumber,
      'bloodGroup': bloodGroup,
      'city': city,
      'dateOfBirth': dateOfBirth,
      'education': education,
      'email': email,
      'emailAddress': emailAddress,
      'fullNameOfMavitra': fullNameOfMavitra,
      'fullNameOfTheMarriedDaughter': fullNameOfTheMarriedDaughter,
      'hobbies': hobbies,
      'image_path': imagePath,
      'isAdmin': isAdmin,
      'isVerified': isVerified,
      'maritalStatus': maritalStatus,
      'marriageDate': marriageDate,
      'mobileOrWhatsappNumber': mobileOrWhatsappNumber,
      'officeAddress': officeAddress,
      'pinCode': pinCode,
      'residentialAddress': residentialAddress,
      'state': state,
      'timestamp': timestamp,
      'totalNumberOfFamilyMembers': totalNumberOfFamilyMembers,
      'villageName': villageName,
    };
  }
}
