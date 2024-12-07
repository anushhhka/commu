import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heyoo/models/base_item_model.dart';

class FirebaseSignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BaseItemModel> sendVerificationCode(String phoneNumber) async {
    try {
      bool userExists = await checkIfUserExists(phoneNumber);
      if (userExists) {
        String verificationId = '';
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: '+91$phoneNumber',
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            throw e;
          },
          codeSent: (String verId, int? resendToken) {
            verificationId = verId;
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
        );
        return BaseItemModel(success: true, data: verificationId);
      } else {
        return BaseItemModel(success: false, error: 'User not found');
      }
    } on FirebaseAuthException catch (e) {
      return BaseItemModel(success: false, error: e.message);
    } catch (e) {
      return BaseItemModel(success: false, error: e.toString());
    }
  }

  Future<BaseItemModel> verifyOTP(String verificationId, String otp) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));
      if (userCredential.user != null) {
        return BaseItemModel(success: true, data: userCredential.user);
      } else {
        return BaseItemModel(success: false, error: 'Invalid OTP');
      }
    } on FirebaseAuthException catch (e) {
      return BaseItemModel(success: false, error: e.message);
    } catch (e) {
      return BaseItemModel(success: false, error: e.toString());
    }
  }

  Future<bool> checkIfUserExists(String phoneNumber) async {
    try {
      // Check if the user exists in the village_member collection
      DocumentReference villageMemberDocRef = _firestore
          .collection('users')
          .doc('village_member')
          .collection('user_details')
          .doc(phoneNumber);

      bool villageMemberExists =
          await villageMemberDocRef.get().then((doc) => doc.exists);

      if (villageMemberExists) {
        return true;
      }

      // Check if the user exists in the niyani collection
      DocumentReference niyaniDocRef = _firestore
          .collection('users')
          .doc('niyani')
          .collection('user_details')
          .doc(phoneNumber);

      bool niyaniExists = await niyaniDocRef.get().then((doc) => doc.exists);

      if (niyaniExists) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
