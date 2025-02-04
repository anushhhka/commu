import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/models/village_member_model.dart';

class FirebaseSignUpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> saveVillageMembersDetails({
    required String userId, // mobile number
    required VillageMemberModel data,
    String? imagePath,
  }) async {
    try {
      // Reference to the user's document in the village_member_users collection
      DocumentReference userDocRef = _firestore.collection('users').doc('village_member').collection('user_details').doc(userId);

      // Save answers to Firestore
      await userDocRef.set(
        data.toJson(),
      );

      //  save phone number to the phone numbe collection
      await _firestore.collection('phone_numbers').doc(userId).set({});

      // Check if the document exists
      return await userDocRef.get().then((doc) => doc.exists);
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveNiyaniDetails({
    required String userId, // mobile number
    required NiyaniModel data,
    String? imagePath,
  }) async {
    try {
      // Reference to the user's document in the village_member_users collection
      DocumentReference userDocRef = _firestore.collection('users').doc('niyani').collection('user_details').doc(userId);

      // Save answers to Firestore
      await userDocRef.set(
        data.toJson(),
      );

      //  save phone number to the phone numbe collection
      await _firestore.collection('phone_numbers').doc(userId).set({});

      // Check if the document exists
      return await userDocRef.get().then((doc) => doc.exists);
    } on FirebaseException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      return false;
    }
  }

  // check if the user is already registered
  Future<BaseItemModel> isUserAleadyRegistered(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('phone_numbers').doc(userId).get();
      return BaseItemModel(success: doc.exists);
    } on FirebaseException catch (e) {
      return BaseItemModel(success: false, error: e.message);
    } catch (e) {
      return BaseItemModel(success: false, error: e.toString());
    }
  }
}
