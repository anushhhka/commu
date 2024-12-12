import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/constants/app_constants.dart';
import 'package:intl/intl.dart';

class NiyaniModel {
  bool isVillageMember;
  final String? profileImage;
  final String email;
  final String fullNameOfMarriedDaughter;
  final String villageName;
  final String fullNameOfMavitra;
  final String dateOfBirth;
  final String education;
  final String bloodGroup;
  final String mobileNumber;
  final String additionalNumber;
  final String hobbies;
  final String residentialAddress;
  final String state;
  final int pinCode;
  final String city;
  final String activityOrEmployeeStatus;
  final String businessOrOfficeAddress;
  final String marriageDate;
  final String maritalStatus;
  final int totalFamilyMembers;

  NiyaniModel({
    this.isVillageMember = false,
    this.profileImage,
    required this.email,
    required this.fullNameOfMarriedDaughter,
    required this.villageName,
    required this.fullNameOfMavitra,
    required this.dateOfBirth,
    required this.education,
    required this.bloodGroup,
    required this.mobileNumber,
    required this.additionalNumber,
    required this.hobbies,
    required this.residentialAddress,
    required this.state,
    required this.pinCode,
    required this.city,
    required this.activityOrEmployeeStatus,
    required this.businessOrOfficeAddress,
    required this.marriageDate,
    required this.maritalStatus,
    required this.totalFamilyMembers,
  });

  factory NiyaniModel.fromJson(Map<String, dynamic> json) {
    final constants = AppConstants();
    final details = json['details'] as Map<String, dynamic>? ?? {};

    return NiyaniModel(
      isVillageMember: json['isVillageMember'] ?? false,
      profileImage: json['image_path'] != null ? json['image_path'] as String : null,
      email: details[constants.niyaniFirstPageQuestions[0]]?.toString() ?? '',
      fullNameOfMarriedDaughter:
          details[constants.niyaniFirstPageQuestions[1]]?.toString() ?? '',
      villageName: details[constants.niyaniFirstPageQuestions[2]]?.toString() ?? '',
      fullNameOfMavitra: details[constants.niyaniFirstPageQuestions[3]]?.toString() ?? '',
      dateOfBirth: details[constants.niyaniSecondPageQuestions[0]] is Timestamp
          ? DateFormat('MMMM dd, yyyy').format((details[constants.niyaniSecondPageQuestions[0]] as Timestamp).toDate())
          : details[constants.niyaniSecondPageQuestions[0]]?.toString() ?? '',
      education: details[constants.niyaniSecondPageQuestions[1]]?.toString() ?? '',
      bloodGroup: details[constants.niyaniSecondPageQuestions[2]]?.toString() ?? '',
      mobileNumber: details[constants.niyaniSecondPageQuestions[3]]?.toString() ?? '',
      additionalNumber: details[constants.niyaniSecondPageQuestions[4]]?.toString() ?? '',
      hobbies: details[constants.niyaniSecondPageQuestions[5]]?.toString() ?? '',
      residentialAddress: details[constants.niyaniThirdPageQuestions[0]]?.toString() ?? '',
      state: details[constants.niyaniThirdPageQuestions[1]]?.toString() ?? '',
      pinCode: int.tryParse(details[constants.niyaniThirdPageQuestions[2]].toString()) ?? 0,
      city: details[constants.niyaniThirdPageQuestions[3]]?.toString() ?? '',
      activityOrEmployeeStatus:
          details[constants.niyaniFourthPageQuestions[0]]?.toString() ?? '',
      businessOrOfficeAddress:
          details[constants.niyaniFourthPageQuestions[1]]?.toString() ?? '',
      marriageDate: details[constants.niyaniFourthPageQuestions[2]] is Timestamp
          ? DateFormat('MMMM dd, yyyy').format((details[constants.niyaniFourthPageQuestions[2]] as Timestamp).toDate())
          : details[constants.niyaniFourthPageQuestions[2]]?.toString() ?? '',
      maritalStatus: details[constants.niyaniFourthPageQuestions[3]]?.toString() ?? '',
      totalFamilyMembers: int.tryParse(
              details[constants.niyaniFourthPageQuestions[4]].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVillageMember': isVillageMember,
      'imagePath': profileImage,
      'details': {
        'email': email,
        'fullNameOfMarriedDaughter': fullNameOfMarriedDaughter,
        'villageName': villageName,
        'fullNameOfMavitra': fullNameOfMavitra,
        'dateOfBirth': dateOfBirth,
        'education': education,
        'bloodGroup': bloodGroup,
        'mobileNumber': mobileNumber,
        'additionalNumber': additionalNumber,
        'hobbies': hobbies,
        'residentialAddress': residentialAddress,
        'state': state,
        'pinCode': pinCode,
        'city': city,
        'activityOrEmployeeStatus': activityOrEmployeeStatus,
        'businessOrOfficeAddress': businessOrOfficeAddress,
        'marriageDate': marriageDate,
        'maritalStatus': maritalStatus,
        'totalFamilyMembers': totalFamilyMembers,
      },
    };
  }

  @override
  String toString() {
    return 'NiyaniModel{isVillageMember: $isVillageMember, email: $email, fullNameOfMarriedDaughter: $fullNameOfMarriedDaughter, villageName: $villageName, fullNameOfMavitra: $fullNameOfMavitra, dateOfBirth: $dateOfBirth, education: $education, bloodGroup: $bloodGroup, mobileNumber: $mobileNumber, additionalNumber: $additionalNumber, hobbies: $hobbies, residentialAddress: $residentialAddress, state: $state, pinCode: $pinCode, city: $city, activityOrEmployeeStatus: $activityOrEmployeeStatus, businessOrOfficeAddress: $businessOrOfficeAddress, marriageDate: $marriageDate, maritalStatus: $maritalStatus, totalFamilyMembers: $totalFamilyMembers}';
  }
}