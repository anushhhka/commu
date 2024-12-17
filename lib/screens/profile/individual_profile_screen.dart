import 'package:flutter/material.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';

class IndividualProfileScreen extends StatelessWidget {
  final NiyaniModel userProfile;
  final String phoneNumber;

  const IndividualProfileScreen(
      {super.key, required this.userProfile, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () async {
            String text =
                'Name: ${userProfile.fullNameOfTheMarriedDaughter} \nPhone Number: $phoneNumber';
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
            _buildRichText('Email: ', userProfile.email),
            _buildRichText('Full Name of Married Daughter: ',
                userProfile.fullNameOfTheMarriedDaughter),
            _buildRichText('Village Name: ', userProfile.villageName),
            _buildRichText(
                'Full Name of Mavitra: ', userProfile.fullNameOfMavitra),
            _buildRichText(
                'Date of Birth: ',
                userProfile.dateOfBirth != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(userProfile.dateOfBirth!.toDate())
                    : 'N/A'),
            _buildRichText('Education: ', userProfile.education),
            _buildRichText('Blood Group: ', userProfile.bloodGroup),
            _buildRichText('Mobile Number: ',
                userProfile.mobileOrWhatsappNumber.toString()),
            // _buildRichText(
            //     'Additional Number: ', userProfile.additionalNumber.toString()),
            _buildRichText('Hobbies: ', userProfile.hobbies),
            _buildRichText(
                'Residential Address: ', userProfile.residentialAddress),
            _buildRichText('State: ', userProfile.state),
            // _buildRichText('Pin Code: ', userProfile.pinCode.toString()),
            _buildRichText('City: ', userProfile.city ?? 'N/A'),
            _buildRichText('Activity/Employee Status: ',
                userProfile.activityOrEmployeeStatus),
            _buildRichText(
                'Business/Office Address: ', userProfile.officeAddress ?? 'N/A'),
            _buildRichText(
                'Marriage Date: ',
                userProfile.dateOfBirth != null
    ? DateFormat('dd/MM/yyyy').format(userProfile.dateOfBirth!.toDate())
    : 'N/A'
),
            _buildRichText('Marital Status: ', userProfile.maritalStatus ?? 'N/A'),
            _buildRichText('Total Family Members: ',
                userProfile.totalNumberOfFamilyMembers.toString()),
          ],
          // ],
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
