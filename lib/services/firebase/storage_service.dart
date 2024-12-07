import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String phoneNumber) async {
    try {
      // Get the file name
      String fileName = basename(imageFile.path);

      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageRef =
          _storage.ref().child('$phoneNumber/profile/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
