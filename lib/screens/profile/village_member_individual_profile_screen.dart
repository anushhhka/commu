import 'package:flutter/material.dart';
import 'package:heyoo/models/village_member_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';

class VillageMemberIndividualProfileScreen extends StatelessWidget {
  final VillageMemberModel userProfile;
  final String phoneNumber;

  const VillageMemberIndividualProfileScreen(
      {super.key, required this.userProfile, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              String text =
                  'Name: ${userProfile.firstNameOfTheMember ?? ''} ${userProfile.surname ?? ''}\nPhone Number: $phoneNumber';
              await Share.share(text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            _buildRichText('First Name: ', userProfile.firstNameOfTheMember ?? 'N/A'),
            _buildRichText('Surname: ', userProfile.surname ?? 'N/A'),
            _buildRichText('Village Name: ', userProfile.villageName ?? 'N/A'),
            _buildRichText('Date of Birth: ', userProfile.dateOfBirth != null
                ? DateFormat('dd/MM/yyyy').format(userProfile.dateOfBirth!.toDate())
                : 'N/A'),
            _buildRichText('Marital Status: ', userProfile.maritalStatus ?? 'N/A'),
            _buildRichText('Marriage Date: ', userProfile.marriageDate != null
                ? DateFormat('dd/MM/yyyy').format(userProfile.marriageDate!.toDate())
                : 'N/A'),
            _buildRichText('Mobile Number: ', userProfile.mobileOrWhatsappNumber?.toString() ?? 'N/A'),
            _buildRichText('Additional Number: ', userProfile.additionalNumber?.toString() ?? 'N/A'),
            _buildRichText('Education: ', userProfile.education ?? 'N/A'),
            _buildRichText('Blood Group: ', userProfile.bloodGroup ?? 'N/A'),
            _buildRichText('Hobbies: ', userProfile.hobbies ?? 'N/A'),
            _buildRichText('Residential Address: ', userProfile.residentialAddress ?? 'N/A'),
            _buildRichText('State: ', userProfile.state ?? 'N/A'),
            // _buildRichText('Pin Code: ', userProfile.pinCode?.toString() ?? 'N/A'),
            _buildRichText('Total Family Members: ',
                userProfile.totalNumberOfFamilyMembers?.toString() ?? 'N/A'),
            _buildRichText('Relation with Head of Family: ',
                userProfile.relationWithHeadOfTheFamily ?? 'N/A'),
            _buildRichText('Mother Name: ', userProfile.motherName ?? 'N/A'),
            _buildRichText('Grandmother/Mother-in-Law Name: ',
                userProfile.grandMotherOrMotherInLawName ?? 'N/A'),
            _buildRichText('Grandfather/Father-in-Law Name: ',
                userProfile.grandfatherOrFatherInLawName ?? 'N/A'),
            _buildRichText('Employee/Activity Status: ',
                userProfile.activityOrEmployeeStatus ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
