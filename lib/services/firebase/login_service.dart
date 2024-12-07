import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heyoo/models/base_item_model.dart';

class FirebaseSignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BaseItemModel> sendVerificationCode(String phoneNumber) async {
    try {
      bool userExists = await _firestore
          .collection('phone_numbers')
          .doc(phoneNumber)
          .get()
          .then((doc) => doc.exists);

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
}
