import 'package:heyoo/constants/app_constants.dart';

class VillageMember {
  bool isVillageMember;
  final String? profileImage;
  final String email;
  final String firstName;
  final String middleNameOrHusbandsName;
  final String mothersName;
  final String grandfathersNameOrFatherInLawsName;
  final String grandmothersNameOrMotherInLawsName;
  final String surname;
  final String fullNameOfFamilyHead;
  final String relationWithHeadOfFamily;
  final String dateOfBirth;
  final String education;
  final String educationStatus;
  final String bloodGroup;
  final String mobileNumber;
  final String additionalNumber;
  final String hobbies;
  final String residentialAddress;
  final String state;
  final String pinCode;
  final String activityOrEmployeeStatus;
  final String businessOrOfficeAddress;
  final String maritalStatus;
  final String marriageDate;
  final String mavitraName;
  final String mavitraVillageName;
  final int totalFamilyMembers;

  VillageMember({
    this.isVillageMember = true,
    this.profileImage,
    required this.email,
    required this.firstName,
    required this.middleNameOrHusbandsName,
    required this.mothersName,
    required this.grandfathersNameOrFatherInLawsName,
    required this.grandmothersNameOrMotherInLawsName,
    required this.surname,
    required this.fullNameOfFamilyHead,
    required this.relationWithHeadOfFamily,
    required this.dateOfBirth,
    required this.education,
    required this.educationStatus,
    required this.bloodGroup,
    required this.mobileNumber,
    required this.additionalNumber,
    required this.hobbies,
    required this.residentialAddress,
    required this.state,
    required this.pinCode,
    required this.activityOrEmployeeStatus,
    required this.businessOrOfficeAddress,
    required this.maritalStatus,
    required this.marriageDate,
    required this.mavitraName,
    required this.mavitraVillageName,
    required this.totalFamilyMembers,
  });

  factory VillageMember.fromJson(Map<String, dynamic> json) {
    final constants = AppConstants();
    final details = json['details'] as Map<String, dynamic>? ?? {};

    return VillageMember(
      isVillageMember: true,
      profileImage: json['imagePath'],
      email: details[constants.villageMemberFirstPageQuestions[0]] ?? '',
      firstName: details[constants.villageMemberFirstPageQuestions[1]] ?? '',
      middleNameOrHusbandsName:
          details[constants.villageMemberFirstPageQuestions[2]] ?? '',
      mothersName: details[constants.villageMemberFirstPageQuestions[3]] ?? '',
      grandfathersNameOrFatherInLawsName:
          details[constants.villageMemberSecondPageQuestions[0]] ?? '',
      grandmothersNameOrMotherInLawsName:
          details[constants.villageMemberSecondPageQuestions[1]] ?? '',
      surname: details[constants.villageMemberSecondPageQuestions[2]] ?? '',
      fullNameOfFamilyHead:
          details[constants.villageMemberSecondPageQuestions[3]] ?? '',
      relationWithHeadOfFamily:
          details[constants.villageMemberSecondPageQuestions[4]] ?? '',
      dateOfBirth: details[constants.villageMemberThirdPageQuestions[0]] ?? '',
      education: details[constants.villageMemberThirdPageQuestions[1]] ?? '',
      educationStatus:
          details[constants.villageMemberThirdPageQuestions[2]] ?? '',
      bloodGroup: details[constants.villageMemberThirdPageQuestions[3]] ?? '',
      mobileNumber: details[constants.villageMemberThirdPageQuestions[4]] ?? '',
      additionalNumber:
          details[constants.villageMemberThirdPageQuestions[5]] ?? '',
      hobbies: details[constants.villageMemberThirdPageQuestions[6]] ?? '',
      residentialAddress:
          details[constants.villageMemberFourthPageQuestions[0]] ?? '',
      state: details[constants.villageMemberFourthPageQuestions[1]] ?? '',
      pinCode: details[constants.villageMemberFourthPageQuestions[2]] ?? '',
      activityOrEmployeeStatus:
          details[constants.villageMemberFourthPageQuestions[3]] ?? '',
      businessOrOfficeAddress:
          details[constants.villageMemberFourthPageQuestions[4]] ?? '',
      maritalStatus:
          details[constants.villageMemberFifthPageQuestions[0]] ?? '',
      marriageDate: details[constants.villageMemberFifthPageQuestions[1]] ?? '',
      mavitraName: details[constants.villageMemberFifthPageQuestions[2]] ?? '',
      mavitraVillageName:
          details[constants.villageMemberFifthPageQuestions[3]] ?? '',
      totalFamilyMembers: int.tryParse(
              details[constants.villageMemberFifthPageQuestions[4]]
                  .toString()) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVillageMember': isVillageMember,
      'imagePath': profileImage,
      'details': {
        'email': email,
        'firstName': firstName,
        'middleNameOrHusbandsName': middleNameOrHusbandsName,
        'mothersName': mothersName,
        'grandfathersNameOrFatherInLawsName':
            grandfathersNameOrFatherInLawsName,
        'grandmothersNameOrMotherInLawsName':
            grandmothersNameOrMotherInLawsName,
        'surname': surname,
        'fullNameOfFamilyHead': fullNameOfFamilyHead,
        'relationWithHeadOfFamily': relationWithHeadOfFamily,
        'dateOfBirth': dateOfBirth,
        'education': education,
        'educationStatus': educationStatus,
        'bloodGroup': bloodGroup,
        'mobileNumber': mobileNumber,
        'additionalNumber': additionalNumber,
        'hobbies': hobbies,
        'residentialAddress': residentialAddress,
        'state': state,
        'pinCode': pinCode,
        'activityOrEmployeeStatus': activityOrEmployeeStatus,
        'businessOrOfficeAddress': businessOrOfficeAddress,
        'maritalStatus': maritalStatus,
        'marriageDate': marriageDate,
        'mavitraName': mavitraName,
        'mavitraVillageName': mavitraVillageName,
        'totalFamilyMembers': totalFamilyMembers,
      },
    };
  }
}
