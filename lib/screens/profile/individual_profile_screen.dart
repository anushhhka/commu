import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/models/village_member_model.dart';

class IndividualProfileScreen extends StatelessWidget {
  final dynamic userProfile;
  final String phoneNumber;

  const IndividualProfileScreen(
      {super.key, required this.userProfile, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final bool isVillageMember = userProfile.isVillageMember;

    final String title =
        isVillageMember ? 'Village Member Address' : 'Niyani Address';

    final String name = userProfile.isVillageMember
        ? '${userProfile.firstName} ${userProfile.surname}'
        : userProfile.fullNameOfMarriedDaughter;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () async {
            String text = 'Name: $name\nPhone Number: $phoneNumber';
            await Share.share(text);
          },
        ),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'User Profile Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (isVillageMember) ...[
              _buildRichText('Email: ', (userProfile as VillageMember).email),
              _buildRichText('First Name: ', userProfile.firstName),
              _buildRichText('Middle Name / Husband\'s Name: ',
                  userProfile.middleNameOrHusbandsName),
              _buildRichText('Mother\'s Name: ', userProfile.mothersName),
              _buildRichText('Grandfather\'s Name / Father in law\'s name: ',
                  userProfile.grandfathersNameOrFatherInLawsName),
              _buildRichText('Grandmother\'s Name / Mother in law\'s name: ',
                  userProfile.grandmothersNameOrMotherInLawsName),
              _buildRichText('Surname: ', userProfile.surname),
              _buildRichText('Full Name of Family Head: ',
                  userProfile.fullNameOfFamilyHead),
              _buildRichText('Relation with Head of the family: ',
                  userProfile.relationWithHeadOfFamily),
              _buildRichText('Date of Birth: ', userProfile.dateOfBirth),
              _buildRichText('Education: ', userProfile.education),
              _buildRichText('Education Status: ', userProfile.educationStatus),
              _buildRichText('Blood Group: ', userProfile.bloodGroup),
              _buildRichText('Mobile Number: ', userProfile.mobileNumber),
              _buildRichText(
                  'Additional Number: ', userProfile.additionalNumber),
              _buildRichText('Hobbies: ', userProfile.hobbies),
              _buildRichText(
                  'Residential Address: ', userProfile.residentialAddress),
              _buildRichText('State: ', userProfile.state),
              _buildRichText('Pin Code: ', userProfile.pinCode),
              _buildRichText('Activity / Employee Status: ',
                  userProfile.activityOrEmployeeStatus),
              _buildRichText('Business / Office Address: ',
                  userProfile.businessOrOfficeAddress),
              _buildRichText('Marital Status: ', userProfile.maritalStatus),
              _buildRichText('Marriage Date: ', userProfile.marriageDate),
              _buildRichText('Mavitra Name: ', userProfile.mavitraName),
              _buildRichText(
                  'Mavitra Village Name: ', userProfile.mavitraVillageName),
              _buildRichText('Total Family Members: ',
                  userProfile.totalFamilyMembers.toString()),
            ] else ...[
              _buildRichText('Email: ', (userProfile as NiyaniModel).email),
              _buildRichText('Full Name of Married Daughter: ',
                  userProfile.fullNameOfMarriedDaughter),
              _buildRichText('Village Name: ', userProfile.villageName),
              _buildRichText(
                  'Full Name of Mavitra: ', userProfile.fullNameOfMavitra),
              _buildRichText('Date of Birth: ', userProfile.dateOfBirth),
              _buildRichText('Education: ', userProfile.education),
              _buildRichText('Blood Group: ', userProfile.bloodGroup),
              _buildRichText('Mobile Number: ', userProfile.mobileNumber),
              _buildRichText(
                  'Additional Number: ', userProfile.additionalNumber),
              _buildRichText('Hobbies: ', userProfile.hobbies),
              _buildRichText(
                  'Residential Address: ', userProfile.residentialAddress),
              _buildRichText('State: ', userProfile.state),
              _buildRichText('Pin Code: ', userProfile.pinCode),
              _buildRichText('City: ', userProfile.city),
              _buildRichText('Activity/Employee Status: ',
                  userProfile.activityOrEmployeeStatus),
              _buildRichText('Business/Office Address: ',
                  userProfile.businessOrOfficeAddress),
              _buildRichText('Marriage Date: ', userProfile.marriageDate),
              _buildRichText('Marital Status: ', userProfile.maritalStatus),
              _buildRichText('Total Family Members: ',
                  userProfile.totalFamilyMembers.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Typo.titleLarge),
          TextFormField(
            enabled: false,
            maxLines: null,
            minLines: 1,
            initialValue: value,
            style: Typo.titleLarge.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
