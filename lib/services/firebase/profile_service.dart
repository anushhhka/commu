import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/models/village_member_model.dart';

class FirebaseProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user profile
  Future<BaseItemModel<dynamic>> fetchUserProfile(String userId) async {
    try {
      // Check if the user is a village member
      DocumentSnapshot villageMemberDoc = await _firestore
          .collection('users')
          .doc('village_member')
          .collection('user_details')
          .doc(userId)
          .get();

      if (villageMemberDoc.exists) {
        VillageMemberModel villageMember = VillageMemberModel.fromJson(
            villageMemberDoc.data() as Map<String, dynamic>);
        return BaseItemModel(
          success: true,
          data: villageMember,
        );
      }

      // Check if the user is a niyani
      DocumentSnapshot niyaniDoc = await _firestore
          .collection('users')
          .doc('niyani')
          .collection('user_details')
          .doc(userId)
          .get();

      if (niyaniDoc.exists) {
        NiyaniModel niyani =
            NiyaniModel.fromJson(niyaniDoc.data() as Map<String, dynamic>);
        return BaseItemModel(
          success: true,
          data: niyani,
        );
      }
      return BaseItemModel(
        success: false,
        error: 'User not found',
      );
    } on FirebaseException catch (e) {
      return BaseItemModel(success: false, error: e.message);
    } catch (e) {
      return BaseItemModel(success: false, error: e.toString());
    }
  }

  Future<List<NiyaniModel>> fetchNiyaniUsersDocument() async {
    try {
      // I want all the list of users
      QuerySnapshot<Map<String, dynamic>> villageMemberDocs = await _firestore
          .collection('users')
          .doc('niyani')
          .collection('user_details')
          .get();

      List<NiyaniModel> niyaniList = villageMemberDocs.docs
          .map((doc) => NiyaniModel.fromJson(doc.data()))
          .toList();

      print(niyaniList.length);

      return niyaniList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<VillageMemberModel>> fetchVillageMemberUsersDocument() async {
    try {
      // I want all the list of users
      QuerySnapshot<Map<String, dynamic>> villageMemberDocs = await _firestore
          .collection('users')
          .doc('village_member')
          .collection('user_details')
          .get();

      List<VillageMemberModel> villageMemberList = villageMemberDocs.docs
          .map((doc) => VillageMemberModel.fromJson(doc.data()))
          .toList();

      print(villageMemberList.length);

      return villageMemberList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
