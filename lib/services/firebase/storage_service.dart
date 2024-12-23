import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String phoneNumber) async {
    try {
      // Get the file name
      String fileName = basename(imageFile.path);

      // Create a reference to the folder you want to upload to in Firebase Storage
      Reference folderRef = _storage.ref().child('$phoneNumber/profile');

      // List all files in the folder
      ListResult result = await folderRef.listAll();

      // Delete all files in the folder
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }

      // Create a reference to the new file location
      Reference storageRef = folderRef.child(fileName);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }
}
