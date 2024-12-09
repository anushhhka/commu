import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heyoo/models/base_item_model.dart';

class FirebaseSignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BaseItemModel> sendVerificationCode(String phoneNumber) async {
    try {
      // Check if the user exists in Firestore
      bool userExists = await _firestore
          .collection('phone_numbers')
          .doc(phoneNumber)
          .get()
          .then((doc) => doc.exists);

      if (!userExists) {
        return BaseItemModel(success: false, error: 'User not found');
      }

      // Use Completer to await verificationId
      final Completer<String> completer = Completer<String>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          completer.completeError('Auto verification completed.');
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(e);
        },
        codeSent: (String verId, int? resendToken) {
          completer.complete(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {
          if (!completer.isCompleted) {
            completer.complete(verId);
          }
        },
      );

      // Wait for the verificationId to be set
      String verificationId = await completer.future;

      return BaseItemModel(success: true, data: verificationId);
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
          verificationId: verificationId,
          smsCode: otp,
        ),
      );

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
