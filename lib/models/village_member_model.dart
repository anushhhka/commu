import 'package:cloud_firestore/cloud_firestore.dart';

class VillageMemberModel {
  final String activityOrEmployeeStatus;
  final int? additionalNumber;
  final String bloodGroup;
  final Timestamp? dateOfBirth;
  final String education;
  final String educationStatus;
  final String email;
  final String emailAddress;
  final String firstNameOfTheMember;
  final String fullNameOfMavitra;
  final String fullNameOfTheFamilyHead;
  final String grandMotherOrMotherInLawName;
  final String grandfatherOrFatherInLawName;
  final String hobbies;
  final String imagePath;
  final bool? isAdmin;
  final bool? isVerified;
  final String maritalStatus;
  final Timestamp? marriageDate;
  final String middleNameFatherOrHusbandName;
  final int? mobileOrWhatsappNumber;
  final String motherName;
  final int? pinCode;
  final String relationWithHeadOfTheFamily;
  final String residentialAddress;
  final String state;
  final String surname;
  final Timestamp? timestamp;
  final int? totalNumberOfFamilyMembers;
  final String villageName;

  VillageMemberModel({
    this.activityOrEmployeeStatus = '',
    this.additionalNumber,
    this.bloodGroup = '',
    this.dateOfBirth,
    this.education = '',
    this.educationStatus = '',
    this.email = '',
    this.emailAddress = '',
    this.firstNameOfTheMember = '',
    this.fullNameOfMavitra = '',
    this.fullNameOfTheFamilyHead = '',
    this.grandMotherOrMotherInLawName = '',
    this.grandfatherOrFatherInLawName = '',
    this.hobbies = '',
    this.imagePath = '',
    this.isAdmin,
    this.isVerified,
    this.maritalStatus = '',
    this.marriageDate,
    this.middleNameFatherOrHusbandName = '',
    this.mobileOrWhatsappNumber,
    this.motherName = '',
    this.pinCode,
    this.relationWithHeadOfTheFamily = '',
    this.residentialAddress = '',
    this.state = '',
    this.surname = '',
    this.timestamp,
    this.totalNumberOfFamilyMembers,
    this.villageName = '',
  });

  /// Factory constructor to parse data from Firestore or JSON.
  factory VillageMemberModel.fromJson(Map<String, dynamic> json) {
    return VillageMemberModel(
      activityOrEmployeeStatus: json['activityOrEmployeeStatus']?.toString() ?? '',
      additionalNumber: json['additionalNumber'] != null
          ? (json['additionalNumber'] is int ? json['additionalNumber'] as int : int.tryParse(json['additionalNumber'].toString()))
          : null,
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth'] as Timestamp?,
      education: json['education']?.toString() ?? '',
      educationStatus: json['educationStatus']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      emailAddress: json['emailAddress']?.toString() ?? '',
      firstNameOfTheMember: json['firstNameOfTheMember']?.toString() ?? '',
      fullNameOfMavitra: json['fullNameOfMavitra']?.toString() ?? '',
      fullNameOfTheFamilyHead: json['fullNameOfTheFamilyHead']?.toString() ?? '',
      grandMotherOrMotherInLawName: json['grandMotherOrMother-in-lawName']?.toString() ?? '',
      grandfatherOrFatherInLawName: json['grandfatherOrFather-in-lawName']?.toString() ?? '',
      hobbies: json['hobbies']?.toString() ?? '',
      imagePath: json['image_path']?.toString() ?? '',
      isAdmin: json['isAdmin'] as bool?,
      isVerified: json['isVerified'] as bool?,
      maritalStatus: json['maritalStatus']?.toString() ?? '',
      marriageDate: json['marriageDate'] as Timestamp?,
      middleNameFatherOrHusbandName: json['middleNameFatherOrHusbandName']?.toString() ?? '',
      mobileOrWhatsappNumber: json['mobileOrWhatsappNumber'] != null
          ? (json['mobileOrWhatsappNumber'] is int ? json['mobileOrWhatsappNumber'] as int : int.tryParse(json['mobileOrWhatsappNumber'].toString()))
          : null,
      motherName: json['motherName']?.toString() ?? '',
      pinCode: json['pinCode'] != null ? (json['pinCode'] is int ? json['pinCode'] as int : int.tryParse(json['pinCode'].toString())) : null,
      relationWithHeadOfTheFamily: json['relationWithHeadOfTheFamily']?.toString() ?? '',
      residentialAddress: json['residentialAddress']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      surname: json['surname']?.toString() ?? '',
      timestamp: json['timestamp'] as Timestamp?,
      totalNumberOfFamilyMembers: json['totalNumberOfFamilyMembers'] != null
          ? (json['totalNumberOfFamilyMembers'] is int
              ? json['totalNumberOfFamilyMembers'] as int
              : int.tryParse(json['totalNumberOfFamilyMembers'].toString()))
          : null,
      villageName: json['villageName']?.toString() ?? '',
    );
  }

  // Method to convert the model to JSON format (useful for uploading data).
  Map<String, dynamic> toJson() {
    return {
      'activityOrEmployeeStatus': activityOrEmployeeStatus,
      'additionalNumber': additionalNumber,
      'bloodGroup': bloodGroup,
      'dateOfBirth': dateOfBirth,
      'education': education,
      'educationStatus': educationStatus,
      'email': email,
      'emailAddress': emailAddress,
      'firstNameOfTheMember': firstNameOfTheMember,
      'fullNameOfMavitra': fullNameOfMavitra,
      'fullNameOfTheFamilyHead': fullNameOfTheFamilyHead,
      'grandMotherOrMother-in-lawName': grandMotherOrMotherInLawName,
      'grandfatherOrFather-in-lawName': grandfatherOrFatherInLawName,
      'hobbies': hobbies,
      'image_path': imagePath,
      'isAdmin': isAdmin,
      'isVerified': isVerified,
      'maritalStatus': maritalStatus,
      'marriageDate': marriageDate,
      'middleNameFatherOrHusbandName': middleNameFatherOrHusbandName,
      'mobileOrWhatsappNumber': mobileOrWhatsappNumber,
      'motherName': motherName,
      'pinCode': pinCode,
      'relationWithHeadOfTheFamily': relationWithHeadOfTheFamily,
      'residentialAddress': residentialAddress,
      'state': state,
      'surname': surname,
      'timestamp': timestamp,
      'totalNumberOfFamilyMembers': totalNumberOfFamilyMembers,
      'villageName': villageName,
    };
  }
}
