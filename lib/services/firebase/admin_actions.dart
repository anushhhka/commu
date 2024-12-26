import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  Future<QuerySnapshot> getUnverifiedUsers() async {
    return await FirebaseFirestore.instance.collectionGroup('user_details').where('isVerified', isEqualTo: false).get();
  }

  Future<void> verifyUser(String userId, bool isNiyani) async {
    final userDocRef;

    if (isNiyani) {
      userDocRef = FirebaseFirestore.instance.collection('users').doc('niyani').collection('user_details').doc(userId);
    } else {
      userDocRef = FirebaseFirestore.instance.collection('users').doc('village_member').collection('user_details').doc(userId);
    }

    try {
      await userDocRef.update({'isVerified': true});
      // get the user's doc to check
      DocumentSnapshot userDoc = await userDocRef.get();
    } catch (e) {
      print('Error verifying user: $e');
      throw e;
    }
  }
}
