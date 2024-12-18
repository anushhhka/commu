import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heyoo/models/base_item_model.dart';

class FirebaseSignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _resendToken;

  Future<BaseItemModel> sendVerificationCode(String phoneNumber) async {
    try {
      // Check if the user exists in Firestore
      bool userExists = await _firestore.collection('phone_numbers').doc(phoneNumber).get().then((doc) => doc.exists);

      if (!userExists) {
        return BaseItemModel(success: false, error: 'User not found');
      }

      // Use Completer to await verificationId
      final Completer<String> completer = Completer<String>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
          completer.completeError('Auto verification completed.');
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(e);
        },
        codeSent: (String verId, int? resendToken) {
          _resendToken = resendToken; // Save the resend token
          print('Resend token: $_resendToken');
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

  Future<BaseItemModel> resendOTP(String phoneNumber) async {
    try {
      // Use Completer to await verificationId
      final Completer<String> completer = Completer<String>();
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        forceResendingToken: _resendToken, // Pass the resend token
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user if the verification completes successfully
          await _firebaseAuth.signInWithCredential(credential);
          completer.completeError('Auto verification completed.');
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? newResendToken) {
          // Use the new verification ID for the next step
          _resendToken = newResendToken;
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
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
